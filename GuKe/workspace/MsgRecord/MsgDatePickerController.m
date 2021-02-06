//
//  MsgDatePickerController.m
//  GuKe
//
//  Created by yb on 2021/2/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "MsgDatePickerController.h"
#import "YZXCalendarHelper.h"
#import "YZXCalendarView.h"
#import "YZXCalendarHeader.h"
#import "UIColor+Hexadecimal.h"

@interface MsgDatePickerController ()<YZXCalendarDelegate>

@property (nonatomic, strong) UIView             *topView;
@property (nonatomic, strong) YZXCalendarHelper *helper;
@property (nonatomic, strong) YZXCalendarView *calendarView;

@end

@implementation MsgDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.calendarView];
    self.calendarView.startDate = self.startDate;
}


//navigationView
- (UIView *)topView
{
    if (!_topView) {
        CGRect rect = CGRectZero;
        if (kDevice_iPhoneX) {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, StatusBarHeight + NavigationBarHeight);
        }else {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, TOPHEIGHT);
        }
        _topView = [[UIView alloc] initWithFrame:rect];
        _topView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"选择聊天记录日期";
        label.textColor = CustomBlackColor;
        label.font = [UIFont systemFontOfSize:16.0];
        [label sizeToFit];
        label.center = CGPointMake(SCREEN_WIDTH / 2.0, (_topView.bounds.size.height - StatusBarHeight) / 2.0 + StatusBarHeight);
        [_topView addSubview:label];
        
//        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancel.frame = CGRectMake(-8, CGRectGetMaxY(_topView.bounds) - 44, 45, 44);
//        cancel.titleLabel.font = [UIFont systemFontOfSize:14.0];
//        [cancel setImage:[UIImage imageNamed:@"返回红"] forState:UIControlStateNormal];
//        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [cancel addTarget:self action:@selector(p_cancelPressed) forControlEvents:UIControlEventTouchUpInside];
//        [_topView addSubview:cancel];
        
        UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightItemButton.frame = CGRectMake(CGRectGetWidth(_topView.bounds)-50, CGRectGetMaxY(_topView.bounds) - 44, 50, 44);
        [rightItemButton setImage:[UIImage imageNamed:@"icon_closed"] forState:UIControlStateNormal];
        [rightItemButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [rightItemButton setTitleColor:CustomColor(@"4990e2") forState:UIControlStateNormal];
        [_topView addSubview:rightItemButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.bounds) - 1, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = CustomLineColor;
        [_topView addSubview:lineView];
        
    }
    return _topView;
}

- (void)buttonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickCalendarDate:(NSString *)date
{
    if (self.selectedDate) {
        NSDate *d =  [NSDate date:date WithFormat:@"yyyy年MM月dd日"];
        NSString *formatteredDate = [d stringWithFormat:@"yyyy-MM-dd"];
        self.selectedDate(formatteredDate);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//日历
- (YZXCalendarView *)calendarView
{
    if (!_calendarView) {
        float topHeight = CGRectGetHeight(self.topView.frame);
        CGRect rect = CGRectMake(0, topHeight, self.view.frame.size.width, SCREEN_HEIGHT - 1 - topHeight);
        _calendarView = [[YZXCalendarView alloc] initWithFrame:rect withStartDateString:self.helper.dayReportStartDate endDateString:self.helper.dayReportEndDate];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (YZXCalendarHelper *)helper
{
    if (!_helper) {
        _helper = [YZXCalendarHelper helper];
    }
    return _helper;
}

@end
