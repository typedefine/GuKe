//
//  ReplyPatientBookTimePopover.m
//  GuKe
//
//  Created by 莹宝 on 2020/9/3.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ReplyPatientBookTimePopover.h"
#import "PatientMessageModel.h"
//#import "ZXFDatePicker.h"

@interface TimeItemView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation TimeItemView


- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(7);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SetColor(0x666666);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"箭头_下"];
    }
    return _arrowView;
}


@end

@interface ReplyPatientBookTimePopover ()//<ZXFDatePickerDelegate>

@property (nonatomic, strong) PatientMessageModel *dataModel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TimeItemView *yearView;
@property (nonatomic, strong) TimeItemView *monthView;
@property (nonatomic, strong) TimeItemView *dayView;
@property (nonatomic, strong) TimeItemView *dayPartView;

@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) ReplyPatientBookTimeHandler reply;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *selectedDate;
//@property (nonatomic, strong) ZXFDatePicker *picker;

@end

@implementation ReplyPatientBookTimePopover

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.hidden = YES;

    [self setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.1]];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.yearView];
    [self.contentView addSubview:self.monthView];
    [self.contentView addSubview:self.dayView];
    [self.contentView addSubview:self.dayPartView];
    [self.contentView addSubview:self.replyButton];
    [self.contentView addSubview:self.cancelButton];
    [self setUpdateConstraints];

    [self.replyButton addTarget:self action:@selector(replyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateReplyBookTime];
}

- (void)setUpdateConstraints
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-60);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(300);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50.0f);
        make.left.right.top.equalTo(self.contentView);
    }];
    
    CGFloat timeHeight = 35;
    
    [self.monthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_centerX).offset(-5);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(timeHeight);
    }];
    
    [self.yearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.monthView);
        make.right.equalTo(self.monthView.mas_left).offset(-10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(timeHeight);
    }];
    
    [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.monthView);
        make.left.equalTo(self.monthView.mas_right).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(timeHeight);
    }];
    
    [self.dayPartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dayView);
        make.left.equalTo(self.dayView.mas_right).offset(10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(timeHeight);
    }];
    
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(-25);
        make.top.equalTo(self.yearView.mas_bottom).offset(35);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(75);
    }];
    [self.replyButton setEnlargeEdge:10.0f];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).with.offset(25);
        make.centerY.equalTo(self.replyButton);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(75);
    }];
    [self.cancelButton setEnlargeEdge:10.0f];
    
}

- (void)updateReplyBookTime
{
    NSDate *date = self.datePicker.date;
    self.selectedDate = date;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitDayFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComps = [gregorian components:unitDayFlags fromDate:date];
    self.yearView.title = @([dateComps year]).stringValue;
    self.monthView.title = @([dateComps month]).stringValue;
    self.dayView.title = @([dateComps day]).stringValue;
    if (dateComps.hour > 12) {
        self.dayPartView.title = @"下午";
    }else{
        self.dayPartView.title = @"上午";
    }
   
}

- (void)replyButtonAction
{
    if (self.reply && self.dataModel) {
        self.reply(self.dataModel, self.datePicker.date);
    }
}

- (void)cancelButtonAction
{
    [self dismiss];
}


- (void)showWithData:(PatientMessageModel *)data reply:(ReplyPatientBookTimeHandler)reply;
{
    self.titleLabel.text = [NSString stringWithFormat:@"回复%@预约就诊时间",data.realName];
    self.reply = [reply copy];
    if (data) {
        if (self.dataModel != data) {
//            if (self.dataModel) {
//                [self.picker resetDate];
//            }
            self.dataModel = data;
        }
    }
    self.dataModel = data;
    [self showInWindow];
}


- (void)showInWindow
{
    if (!self.hidden) return;
    self.hidden = NO;
    self.alpha = 0;
    self.contentView.alpha = 0;
    UIView *rootView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [rootView addSubview:self];
    self.frame = rootView.bounds;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 1.0f;
        self.contentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    if (self.hidden) return;
    self.hidden = YES;
    self.alpha = 1.0f;
    self.contentView.alpha = 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)pickDate
{
    if (self.selectedDate) {
        self.datePicker.date = self.selectedDate;
    }
    [self.datePicker becomeFirstResponder];
}


- (void)addTapAction:(UIView *)superView
{
    [superView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickDate)]];
}

- (void)setBorder:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = SetColor(0x999999).CGColor;
    view.layer.borderWidth = 1;
}


- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self setBorder:_contentView cornerRadius:10];
    }
    return _contentView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SetColor(0x666666);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (TimeItemView *)yearView
{
    if (!_yearView) {
        _yearView = [[TimeItemView alloc] init];
        [self setBorder:_yearView cornerRadius:8];
        [self addTapAction:_yearView];
    }
    return _yearView;
}

- (TimeItemView *)monthView
{
    if (!_monthView) {
        _monthView = [[TimeItemView alloc] init];
        [self setBorder:_monthView cornerRadius:8];
        [self addTapAction:_monthView];
    }
    return _monthView;
}

- (TimeItemView *)dayView
{
    if (!_dayView) {
        _dayView = [[TimeItemView alloc] init];
        [self setBorder:_dayView cornerRadius:8];
        [self addTapAction:_dayView];
    }
    return _dayView;
}

- (TimeItemView *)dayPartView
{
    if (!_dayPartView) {
        _dayPartView = [[TimeItemView alloc] init];
        [self setBorder:_dayPartView cornerRadius:8];
        [self addTapAction:_dayPartView];
    }
    return _dayPartView;
}



- (UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:SetColor(0x999999) forState:UIControlStateNormal];
        [self setBorder:_replyButton cornerRadius:8];
    }
    return _replyButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SetColor(0x999999) forState:UIControlStateNormal];
        [self setBorder:_cancelButton cornerRadius:8];
    }
    return _cancelButton;
}
- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.tintColor = SetColor(0x666666);
//        1. "en_GB"英文 24小时
//        2. "zh_GB"中文24小时
//        3. ”zh_CN“中文12小时
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        [_datePicker setDate:[NSDate date] animated:YES];
        //监听DataPicker的滚动
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    [self updateReplyBookTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy年 MM月 dd日";
    NSString *dateFormatterValue = [formatter  stringFromDate:datePicker.date];
    NSLog(@"ZXFDatePicker------:%@",dateFormatterValue);
}

/*
- (ZXFDatePicker *)picker
{
    if (!_picker) {
        _picker = [[ZXFDatePicker alloc] init];
        _picker.title = @"请选择时间";
        _picker.delegate = self;
    }
    return _picker;
}

-(void)pickerView:(ZXFDatePicker *)pickerView didSelectWithselectedDate:(NSDate *)date
{
    [self updateReplyBookTime];
}

- (void)pickerView:(ZXFDatePicker *)pickerView didCancelWithselectedDate:(NSDate *)date
{
    
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
