//
//  UIButton+Additions.h
//  MobileCRM
//
//  Created by wangweishun on 7/22/14.
//  Copyright (c) 2014 wangweishun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);


typedef NS_ENUM(NSInteger, EButtonTitlePostionType) {
    EButtonTitlePostionTypeBottom = 0,        // text below the image
    EButtonTitlePostionTypeTop,               // text above the image
    EButtonTitlePostionTypeLeft,              // text on the left of the image
    EButtonTitlePostionTypeRight              // text on the right of the image
};

@interface UIButton (Additions)

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)block;

/**
*  @param type  the title position
*  @param space the space between the image and text
*/
- (void)setTitlePositionWithType:(EButtonTitlePostionType)type space:(CGFloat)space;

+ (UIButton *)buttonWithColor:(UIColor *)color title:(NSString *)title;
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)color title:(NSString *)title;
+ (UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image;
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title;
+ (UIButton *)buttonWithColor:(UIColor *)color title:(NSString *)title icon:(UIImage *)icon;

@end
