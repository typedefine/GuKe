//
//  ZJNTextView.h
//  TextFieldHeightChange2
//
//  Created by 朱佳男 on 2017/9/25.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
FOUNDATION_EXPORT double SZTextViewVersionNumber;

FOUNDATION_EXPORT const unsigned char SZTextViewVersionString[];

IB_DESIGNABLE
@interface ZJNTextView : UITextView
@property (copy, nonatomic) IBInspectable NSString *placeholder;
@property (nonatomic) IBInspectable double fadeTime;
@property (copy, nonatomic) NSAttributedString *attributedPlaceholder;
@property (retain, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;

@end
