//
//  ZJNDatePickerView.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/20.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNDatePickerDelegate<NSObject>
-(void)getSelectedDate:(NSString *)selectedDate;
-(void)getCenterDatePicker;
@end
@interface ZJNDatePickerView : UIView
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UIButton * cannelBtn;
@property (nonatomic ,weak)id<ZJNDatePickerDelegate>delegate;
@end
