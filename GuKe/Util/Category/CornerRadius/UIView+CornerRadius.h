//
//  UIView+CornerRadius.h
//  TSC_Dashboard
//
//  Created by tsc on 2018/5/17.
//  Copyright © 2018年 TSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (void)clipCornerWithCornerRadius:(CGFloat)cornerRadius byRoundingCorners:(UIRectCorner)roundingCorners;

- (void)clipCornerWithCornerRadius:(CGFloat)cornerRadius;

@end
