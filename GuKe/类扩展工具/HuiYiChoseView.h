//
//  HuiYiChoseView.h
//  GuKe
//
//  Created by yu on 2017/8/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HuiYiViewDelegate <NSObject>
- (void)getSelectViewDate:(NSString *)date;
- (void)getViewcancel;
@end
@interface HuiYiChoseView : UIView
@property(nonatomic,strong)UIDatePicker * datePickerView;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UIButton * cannelBtn;

@property (nonatomic,weak)id<HuiYiViewDelegate> delegate;
+(id)datePickerChoseView;
@end
