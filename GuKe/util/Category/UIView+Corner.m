//
//  UIView+Corner.m
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

/*
- (UIImage *)drawRectWithRoundedCornerWithRadius:(CGFloat)radius //borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, 0, 0, 0, size.width, radius);
    CGContextAddArcToPoint(context, 0, size.width, size.width, size.height, radius); // 这种类型的代码重复四次
    CGContextAddArcToPoint(context, size.width, size.height, 0, size.height, radius);
    CGContextAddArcToPoint(context, 0, size.height, 0, 0, radius);

    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (void)addCornerWithRadius:(CGFloat)radius //borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor
                     
{        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self drawRectWithRoundedCornerWithRadius:radius]];
    [self insertSubview:imageView atIndex:0];
}
*/

- (void)addCornerWithRadius:(CGFloat)radius
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置一个范围
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    //给上下文画一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    //裁剪
    CGContextClip(ctx);
    //开始绘图
    [self drawRect:self.bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self insertSubview:imageView atIndex:0];
}






@end
