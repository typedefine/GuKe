//
//  WorkGroupTitleView.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupsTitleView.h"

@interface WorkGroupsTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addWorkSpaceBtn;

@end

@implementation WorkGroupsTitleView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(20);
    }];
    
    [self addSubview:self.addWorkSpaceBtn];
    [self.addWorkSpaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-20);
    }];
    self.title = @"工作室";
    self.subTitle = @"申请开通工作室";
    [self.addWorkSpaceBtn addTarget:self action:@selector(addWorkSpace) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addWorkSpace
{
    if (self.action) {
        self.action();
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (title != nil) {
        self.titleLabel.text = title;
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    
    if (subTitle != nil) {
        [self.addWorkSpaceBtn setTitle:subTitle forState:UIControlStateNormal];
    }
}

- (UIButton *)addWorkSpaceBtn
{
    if (!_addWorkSpaceBtn) {
        _addWorkSpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addWorkSpaceBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_addWorkSpaceBtn setTitleColor:greenC forState:UIControlStateNormal];
    }
    return _addWorkSpaceBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
