//
//  CountButton.h
//  kechematou
//
//  Created by Ymm on 15/7/28.
//  Copyright (c) 2015年 kechematou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountButton : UIButton

+ (CountButton *)countButtonWith:(SEL)method WithTarget:(id)target;
-(void)startTime;
-(void)WXstartTime;
@end
