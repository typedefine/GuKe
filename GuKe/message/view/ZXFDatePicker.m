//
//  ReplyMedicalBookAlert.m
//  GuKe
//
//  Created by 莹宝 on 2020/9/1.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFDatePicker.h"

@interface ZXFDatePicker ()

@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView* topBar;
@property (nonatomic, strong) UIButton *comfirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSDate *displayDate;


@end

@implementation ZXFDatePicker
@synthesize pickerView = _pickerView;
@synthesize backgroundView = _backgroundView;
@synthesize titleLabel = _titleLabel;
@synthesize selectedDate;


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
//    self.componentWidth = DEVICE_WIDTH;
    
    [self setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.6]];
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.topBar];
    [self.topBar addSubview:self.cancelButton];
    [self.topBar addSubview:self.titleLabel];
    [self.topBar addSubview:self.comfirmButton];
    [self.backgroundView addSubview:self.pickerView];
    [self setUpdateConstraints];
    
    selectedDate = self.pickerView.date;
}


- (void)setUpdateConstraints
{
    CGFloat safeHeight = TabbarHeight-49;
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-250-safeHeight);
        make.bottom.equalTo(self.mas_bottom).offset(-safeHeight);
        make.left.right.equalTo(self);
    }];
    
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(43.0f);
        make.left.right.top.equalTo(self.backgroundView);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBar).with.offset(10);
        make.centerY.equalTo(self.topBar);
        make.width.height.mas_equalTo(40.0f);
    }];
    [self.cancelButton setEnlargeEdge:10.0f];
    
    [self.comfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBar);
        make.right.equalTo(self.topBar);
        make.width.height.mas_equalTo(40.0f);
    }];
    [self.comfirmButton setEnlargeEdge:10.0f];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topBar);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView).insets(UIEdgeInsetsMake(40, 0, 5, 0));
    }];
}



- (void)showWithSelectedDate:(NSDate *)date
{
    if (date) {
        self.displayDate = date;
        selectedDate = date;
//        [self.pickerView selectRow:selectItem.row inComponent:selectItem.section animated:YES];
    }
    [self showInWindow];
}

- (void)show
{
    [self showInWindow];
}


- (void)showInWindow
{
    if (!self.hidden) return;
    self.hidden = NO;
    self.alpha = 0;
    self.backgroundView.alpha = 0;
    UIView *rootView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [rootView addSubview:self];
    self.frame = rootView.bounds;
    
    if (self.displayDate) {
        self.pickerView.date = self.displayDate;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 1.0f;
        self.backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    if (self.hidden) return;
    self.hidden = YES;
    self.alpha = 1.0f;
    self.backgroundView.alpha = 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)resetDate
{
    selectedDate = self.displayDate = [NSDate date];
}

#pragma mark - private -

- (void)comfirmButtonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectWithselectedDate:)]) {
        [self.delegate pickerView:self didSelectWithselectedDate:selectedDate = self.displayDate];
    }
    [self dismiss];
}


- (void)cancelButtonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didCancelWithselectedDate:)]) {
        [self.delegate pickerView:self didCancelWithselectedDate:self.displayDate = self.selectedDate];
    }
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGRect rect = [self convertRect:self.backgroundView.frame toView:self];
    if (!CGRectContainsPoint(rect, touchPoint)){
        [self cancelButtonAction];
    }
}


- (void)dateChange:(UIDatePicker *)datePicker {
    
    self.displayDate = datePicker.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy年 MM月 dd日";
    NSString *dateFormatterValue = [formatter  stringFromDate:datePicker.date];
    NSLog(@"ZXFDatePicker------:%@",dateFormatterValue);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (UIDatePicker *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIDatePicker alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.tintColor = SetColor(0x666666);
//        1. "en_GB"英文 24小时
//        2. "zh_GB"中文24小时
//        3. ”zh_CN“中文12小时
        _pickerView.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        _pickerView.minimumDate = [NSDate date];
        [_pickerView setDate:[NSDate date] animated:YES];
        //监听DataPicker的滚动
        [_pickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _pickerView;
}



- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.userInteractionEnabled = YES;
    }
    return _backgroundView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = SetFont(16);
        _titleLabel.textColor = SetColor(0x666666);
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIView alloc]init];
        _topBar.backgroundColor = SetColor(0xF2F2F2);
    }
    return _topBar;
}


- (UIButton *)comfirmButton
{
    if (!_comfirmButton) {
        _comfirmButton = [[UIButton alloc] init];
        _comfirmButton.titleLabel.font = SetFont(14);
        [_comfirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_comfirmButton setTitleColor:SetColor(0x333333) forState:UIControlStateNormal];
        [_comfirmButton addTarget:self action:@selector(comfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = SetFont(14);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SetColor(0x333333) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
