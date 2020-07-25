//
//  MedicalRecordsImageTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MedicalRecordsImageTableViewCell.h"
#define imageWidth (ScreenWidth-50)/4
@interface MedicalRecordsImageTableViewCell()

@end

@implementation MedicalRecordsImageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier topStyle:(NSString *)topStyle{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topStyle = topStyle;
        [self creatView];
    }
    return self;
}
-(void)creatView{
    if ([_topStyle isEqualToString:@"topButton"]) {
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
        titleLable.font = Font14;
        titleLable.textColor = SetColor(0x1a1a1a);
        titleLable.text = @"病例报告";
        [self addSubview:titleLable];
        
        UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        compareBtn.frame = CGRectMake(ScreenWidth-75, 7.5, 65, 25);
        [compareBtn addTarget:self action:@selector(compareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        compareBtn.titleLabel.font = Font14;
        compareBtn.backgroundColor = SetColor(0x06a27b);
        [Utile makeCorner:5 view:compareBtn];
        [compareBtn setTitle:@"对比" forState:UIControlStateNormal];
        [self addSubview:compareBtn];
        
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(compareBtn.x-71, 7.5, 65, 25);
        [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
        editButton.titleLabel.font = Font14;
        editButton.backgroundColor = SetColor(0x06a27b);
        [Utile makeCorner:5 view:editButton];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self addSubview:editButton];
        
        _topHeight = 40;
    }else{
        
        _topHeight = 0;
    }
    NSArray *titleArray = @[@"化验单",@"X光",@"体位照",@"步态小视频"];
    for (int i = 0; i <titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10+i;
        button.titleLabel.font = Font14;
        if (i==titleArray.count-1) {
            button.frame = CGRectMake(i*(ScreenWidth/4.0), _topHeight, ScreenWidth/4.0, 35);
        }else{
            button.frame = CGRectMake(i*(ScreenWidth/4.0), _topHeight, ScreenWidth/4.0-1, 35);
        }
        if (i == 0) {
            button.backgroundColor = greenC;
        }else{
            button.backgroundColor = SetColor(0xcccccc);
        }
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(middleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)setImageArray:(NSArray *)imageArray{
    NSArray *subviewsArr = self.subviews;
    [subviewsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)obj;
            [imageView removeFromSuperview];
        }
    }];
    _imageArray = imageArray;
    for (int i = 0; i <_imageArray.count; i++) {
        int x = i%4;
        int y = i/4;
        NSDictionary *dic = self.imageArray[i];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10+x*(imageWidth+10), 45+_topHeight+y*(imageWidth+10), imageWidth, imageWidth)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        NSString *imagePath = dic[@"path"];
        NSString *typeStr = [[imagePath componentsSeparatedByString:@"."] lastObject];
        if ([typeStr isEqualToString:@"mp4"]) {
            imageV.image = [UIImage imageNamed:@"default_img"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作在此次添加
                UIImage *image = [Utile imageWithMediaURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,imagePath]]];
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //在主线程刷新UI
                    imageV.image = image;
                });
                
            });
        }else{
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,dic[@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
        }
        
        [Utile addClickEvent:self action:@selector(previewPicture:) owner:imageV];
        imageV.tag = 100+i;
        [self addSubview:imageV];
    }
}
//
-(void)middleButtonClick:(UIButton *)button{
    
    for (int i = 0; i <4; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:10+i];
        button.backgroundColor = SetColor(0xcccccc);
    }
    
    button.backgroundColor = greenC;
    
    NSString *signStr;
    if (button.tag == 10) {
        signStr = @"hy";
    }else if (button.tag == 11){
        signStr = @"X";
    }else if (button.tag == 12){
        signStr = @"tw";
    }else{
        signStr = @"videos";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchImageArrayWithType:withCell:)]) {
        [self.delegate switchImageArrayWithType:signStr withCell:self];
    }
}
//预览图片
-(void)previewPicture:(UIGestureRecognizer *)recognizer{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showImageWithIndex:withCell:)]) {
        [self.delegate showImageWithIndex:imageView.tag-100 withCell:self];
    }
}
-(void)compareBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(comPareInfoWithCell:)]) {
        [self.delegate comPareInfoWithCell:self];
    }
}
-(void)editButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editImageWithCell:)]) {
        [self.delegate editImageWithCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
