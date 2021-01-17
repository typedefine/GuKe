//
//  GroupVideoFooterView.m
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupVideoFooterView.h"

@interface GroupVideoFooterView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *iconView;

@end

@implementation GroupVideoFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-5);
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.height.mas_equalTo(7);
        make.width.mas_equalTo(13);
    }];
}

- (void)configWithTarget:(id)target action:(SEL)action
{
    if (target && action) {
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHex:0x8C8C8C];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _titleLabel.text = @"收起";
    }
    return _titleLabel;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"arrow_up"];
    }
    return _iconView;
}

@end

