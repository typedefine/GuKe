//
//  TitleAndImageViewTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "TitleAndImageViewTableViewCell.h"
#define imageWidth (ScreenWidth-30-20)/3
#define imageHeight 0.77*imageWidth
@interface TitleAndImageViewTableViewCell()
{
    
}
@end
@implementation TitleAndImageViewTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 20)];
        _titleLabel.textColor = SetColor(0x1a1a1a);
        _titleLabel.font = Font14;
    }
    return _titleLabel;
}
-(void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    NSArray *subviews = self.subviews;
    [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }];
    for (int i = 0; i <imageArray.count; i++) {
        int x = i%3;
        int y = i/3;
        NSDictionary *dic = self.imageArray[i];
        

        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15+x*(imageWidth+10), 45+y*(imageHeight+10), imageWidth, imageHeight)];
        imageV.contentMode=UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds=YES;
        if ([[dic objectForKey:@"path"] hasSuffix:@".mp4"]) {

            imageV.image =[UIImage imageNamed:@"小视频占位图12"];
            dispatch_group_t group = dispatch_group_create();
            UIImage * image ;
            __block UIImage* BlockImaeg = image;
            dispatch_group_async(group,dispatch_get_global_queue(0, 0), ^{
                BlockImaeg= [Utile imageWithMediaURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[dic objectForKey:@"path"]]]];

            });
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                imageV.image= BlockImaeg;
            });
        }else{
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,dic[@"path"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];

                    }

        [Utile addClickEvent:self action:@selector(previewPicture:) owner:imageV];
        imageV.tag = 10+i;
        [self addSubview:imageV];
        
    }
}

-(void)previewPicture:(UIGestureRecognizer *)recognizer{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showImageWithIndex:withCell:)]) {
        [self.delegate showImageWithIndex:imageView.tag-10 withCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
