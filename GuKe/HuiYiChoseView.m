//
//  HuiYiChoseView.m
//  GuKe
//
//  Created by yu on 2017/8/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "HuiYiChoseView.h"
@interface HuiYiChoseView ()
@property (nonatomic, strong) NSString *selectDate;

@end
@implementation HuiYiChoseView
+(id)datePickerChoseView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * toolView = [[UIView alloc]init];
        [self addSubview:toolView];
        toolView.frame = CGRectMake(0, 0, ScreenWidth, 42);
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(ScreenWidth-18-33, 10, 33, 22);
        [toolView addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:titColor forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(18, 10, 33, 22);
        [toolView addSubview:_cannelBtn];
        
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:titColor forState:UIControlStateNormal];
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UILabel * titleLab = [[UILabel alloc]init];
        [toolView addSubview:titleLab];
        titleLab.frame = CGRectMake((ScreenWidth-130)/2, 12, 130, 17);
        // titleLab.text = @"请选择申请日期";
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.textColor = titColor;
        
        UIView * lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.frame = CGRectMake(0, 42, ScreenWidth, 0.5);
        lineView.backgroundColor = titColor;
        
        
        _datePickerView = [[UIDatePicker alloc]init];
        [_datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        _datePickerView.locale = [[NSLocale alloc]
                                  initWithLocaleIdentifier:@"zh_CN"];
        _datePickerView.frame = CGRectMake(0, 52, ScreenWidth, 132);
        [self addSubview:_datePickerView];
        
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}
-(void)cannelBtnClick{
    [self.delegate getViewcancel];
}
-(void)sureBtnClick
{
    self.selectDate = [self timeFormat];
    //delegate
    [self.delegate getSelectViewDate:self.selectDate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
