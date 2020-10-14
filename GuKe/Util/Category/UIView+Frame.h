//
//  UIView+Frame.h
//  Pods
//
//  Created by tsc on 2018/1/19.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGFloat)origin_x;
- (void)setOrigin_x:(CGFloat)origin_x;

- (CGFloat)origin_y;
- (void)setOrigin_y:(CGFloat)origin_y;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)center_x;
- (void)setCenter_x:(CGFloat)center_x;

- (CGFloat)center_y;
- (void)setCenter_y:(CGFloat)center_y;

@end
