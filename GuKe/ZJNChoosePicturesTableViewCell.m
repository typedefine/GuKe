//
//  ZJNChoosePicturesTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNChoosePicturesTableViewCell.h"

#define kPadding 10
#define imageWidth (ScreenWidth-50)/4.0

@implementation ZJNChoosePicturesTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setImageArray:(NSArray *)imageArray{
    
    _imageArray = imageArray;
    NSArray *subviews = self.subviews;
    [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]||[obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    if (_imageArray.count == 0) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, imageWidth, imageWidth)];
        imageV.image = [UIImage imageNamed:@"上传图片"];
        [Utile addClickEvent:self action:@selector(addPictures:) owner:imageV];
        [self addSubview:imageV];
    }else{
        NSInteger count;
        if (_imageArray.count<16) {
            count = _imageArray.count+1;
        }else{
            count = 16;
        }
        for (int i = 0; i <count; i++) {
            int x = i%4;
            int y = i/4;
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10+x*(imageWidth+10), 10+y*(imageWidth+10), imageWidth, imageWidth)];
            if (i == imageArray.count && imageArray.count<16) {
                
                imageV.image = [UIImage imageNamed:@"上传图片"];
                [Utile addClickEvent:self action:@selector(addPictures:) owner:imageV];
                [self addSubview:imageV];
            }else{
                if ([_imageArray[i] isKindOfClass:[UIImage class]]) {
                    imageV.image = _imageArray[i];
                }else{
 
                    if ([_imageArray[i] hasSuffix:@".mp4"]) {
                    
//                       imageV.image    = [Utile imageWithMediaURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,_imageArray[i]]]];
                        imageV.image =[UIImage imageNamed:@"小视频占位图12"];
                        dispatch_group_t group = dispatch_group_create();
                        UIImage * image ;
                        __block UIImage* BlockImaeg = image;
                        dispatch_group_async(group,dispatch_get_global_queue(0, 0), ^{
                            BlockImaeg= [Utile imageWithMediaURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,_imageArray[i]]]];
                            
                        });
                        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                            imageV.image= BlockImaeg;
                        });
                        
                    }else{
//                        有些数据返回的格式不一样所以 需要这样处理下
                        NSString * ImageStr  = [NSString stringWithFormat:@"%@",_imageArray[i]];
                        if ([ImageStr containsString:imgPath]) {
                            
                        }else{
                            ImageStr =  [NSString stringWithFormat:@"%@%@",imgPath,ImageStr];

                        }
                        
                        [imageV sd_setImageWithURL:[NSURL URLWithString:ImageStr] placeholderImage:[UIImage imageNamed:@"default_img"]];
                        
                    }

                    
                }
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                imageV.clipsToBounds = YES;
                imageV.tag = 10+i;
                [Utile addClickEvent:self action:@selector(previewPicture:) owner:imageV];
                [self addSubview:imageV];
                UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
                delButton.frame = CGRectMake(CGRectGetMaxX(imageV.frame)-10, CGRectGetMinY(imageV.frame)-10, 20, 20);
                [Utile makeCorner:10 view:delButton];
                [delButton setImage:[UIImage imageNamed:@"删"] forState:UIControlStateNormal];
                delButton.tag = 100+i;
                [delButton addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:delButton];
            }
        }
    }
    
}
/*
 * 添加图片
 */
-(void)addPictures:(UIGestureRecognizer *)recognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePicturesTableViewCellAddPicturesWithCell:)]) {
        [self.delegate choosePicturesTableViewCellAddPicturesWithCell:self];
    }
}

/*
 * 预览图片
 */
-(void)previewPicture:(UIGestureRecognizer *)recognizer{
    UIImageView *imageV = (UIImageView *)recognizer.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePicturesTableViewCellPreviewPictureWithIndex:withCell:)]) {
        [self.delegate choosePicturesTableViewCellPreviewPictureWithIndex:(imageV.tag-10) withCell:self];
    }
}
/*
 * 删除图片
 */
-(void)deletePicture:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(choosePicturesTableViewCellDeletePictureWithIndex:withCell:)]) {
        [self.delegate choosePicturesTableViewCellDeletePictureWithIndex:button.tag-100 withCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
