//
//  UIButton+Additions.m
//  MobileCRM
//
//  Created by wangweishun on 7/22/14.
//  Copyright (c) 2014 wangweishun. All rights reserved.
//

#import "UIButton+Additions.h"
#import <objc/runtime.h>

@implementation UIButton (Additions)

static char overviewKey;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)block{
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvent];
}
- (void)callActionBlock:(id)sender{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

///position
- (void)setTitlePositionWithType:(EButtonTitlePostionType)type space:(CGFloat)space
{
     CGSize imageSize = self.imageView.frame.size;
     CGSize titleSize = self.titleLabel.frame.size;
    switch (type) {
        case EButtonTitlePostionTypeBottom: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (imageSize.height + space), 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + space), 0, 0, - titleSize.width);
            break;
        }
        case EButtonTitlePostionTypeTop: {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageSize.height + space), -imageSize.width, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -(titleSize.height + space), -titleSize.width);
            break;
        }
        case EButtonTitlePostionTypeLeft: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(titleSize.width * 2 + imageSize.width));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(space + imageSize.width * 2), 0,  0);
            break;
        }
        case EButtonTitlePostionTypeRight: {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space, 0, 0);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space);
            break;
        }
        default:
            break;
    }
}

///
////////////////////辅助
+ (UIButton *)buttonWithColor:(UIColor *)color title:(NSString *)title icon:(UIImage *)icon
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 90, 60);
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 60)];
    button.backgroundColor = color;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setImage:icon forState:UIControlStateNormal];
    [button setImage:icon forState:UIControlStateHighlighted];
    [button setTitlePositionWithType:EButtonTitlePostionTypeBottom space:3];
    return button;
}

+ (UIButton *)buttonWithColor:(UIColor *)color title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    return button;
}

+ (UIButton *)buttonWithBackgroundColor:(UIColor *)color title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}


+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
@end
