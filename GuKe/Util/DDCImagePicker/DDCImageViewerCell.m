//
//  DDCImageViewerCell.m
//  DayDayCook
//
//  Created by Christopher Wood on 11/4/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageViewerCell.h"

@interface DDCImageViewerCell()

@property (nonatomic, strong) UIImageView                * imageView;

@end

@implementation DDCImageViewerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    _scrollView = [[DDCImageViewerScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _imageView = [[UIImageView alloc] init];
    _scrollView.childView = _imageView;
    
    return self;
}

-(void)setImage:(UIImage *)image
{
    _imageView.hidden = YES;
    _imageView.image = image;
    [self updateImageViewFrame:image];
}

-(void)updateImageViewFrame:(UIImage*)image
{
    CGSize imageSize = image.size;
    CGSize imageViewSize;
    
    if (imageSize.width > ScreenWidth)
    {
        imageViewSize = CGSizeMake(ScreenWidth, imageSize.height/imageSize.width * ScreenWidth);
        if (imageViewSize.height > ScreenHeight)
        {
            imageViewSize = CGSizeMake(imageSize.width/imageSize.height * ScreenHeight, ScreenHeight);
        }
    }
    else
    {
        if (imageSize.height > ScreenHeight)
        {
            imageViewSize = CGSizeMake(imageSize.width/imageSize.height * ScreenHeight, ScreenHeight);
        }
        else
        {
            imageViewSize = imageSize;
        }
    }
    
    _imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    _imageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    _scrollView.childView = _imageView;
    _imageView.hidden = NO;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end
