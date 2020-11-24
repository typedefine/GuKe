//
//  UIImageView+Corner.m
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "UIImageView+Corner.h"

@implementation UIImageView (Corner)
/*
- (UIImage *)drawRectWithRoundedCornerWithRadius:(CGFloat)radius sizetoFit:(CGSize)sizetoFit
{        CGRect rect = CGRectMake(0, 0, sizetoFit.width, sizetoFit.height);     UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    CGContextAddPath(UIGraphicsGetCurrentContext(), path);        CGContextClip(UIGraphicsGetCurrentContext());
    [self drawRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();        UIGraphicsEndImageContext();
    return output;
}

- (void)addCornerWithRadius:(CGFloat)radius
{
    self.image = [self drawRectWithRoundedCornerWithRadius:radius sizetoFit:self.bounds.size];
}
*/

- (void)addCornerWithRadius:(CGFloat)radius
{
    //创建新的位图
    //size 新位图的大小 opaque 透明开关 scale 缩放因子 设置为0 系统自动匹配
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //用贝塞尔曲线画一个圆形 addClip 进行切割
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius] addClip];
    //开始绘图
    [self drawRect:self.bounds];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画图
    UIGraphicsEndImageContext();
}


@end
