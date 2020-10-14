//
//  UIView+Frame.m
//  Pods
//
//  Created by tsc on 2018/1/19.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)origin_x
{
    return self.frame.origin.x;
}

- (void)setOrigin_x:(CGFloat)origin_x
{
    CGRect f = self.frame;
    f.origin.x = origin_x;
    self.frame = f;
}

- (CGFloat)origin_y
{
    return self.frame.origin.y;
}

- (void)setOrigin_y:(CGFloat)origin_y
{
    CGRect f = self.frame;
    f.origin.y = origin_y;
    self.frame = f;
}

- (CGSize)size

{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect f = self.frame;
    f.size = size;
    self.frame = f;
}

- (CGFloat)width
{
    return self.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect f = self.frame;
    f.size.width = width;
    self.frame = f;
}

- (CGFloat)height
{
    return self.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}

- (CGFloat)center_x
{
    return self.center.x;
}

- (void)setCenter_x:(CGFloat)center_x
{
    CGPoint center = self.center;
    center.x = center_x;
    self.center = center;
}


- (CGFloat)center_y
{
    return self.center.y;
}

- (void)setCenter_y:(CGFloat)center_y
{
    CGPoint center = self.center;
    center.y = center_y;
    self.center = center;
}

@end
