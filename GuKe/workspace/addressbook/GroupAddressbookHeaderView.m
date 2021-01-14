//
//  GroupAddressbookHeaderView.m
//  GuKe
//
//  Created by yb on 2021/1/14.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupAddressbookHeaderView.h"

@interface GroupAddressbookHeaderView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation GroupAddressbookHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

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

- (void)setup
{
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(IPHONE_X_SCALE(20));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(IPHONE_X_SCALE(20));
        make.height.mas_equalTo(IPHONE_X_SCALE(20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(6);
        make.centerY.equalTo(self);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-IPHONE_X_SCALE(20));
        make.height.mas_equalTo(IPHONE_Y_SCALE(14));
        make.width.mas_equalTo(IPHONE_X_SCALE(8));
    }];
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"group_invite"];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.text = @"邀请好友";
    }
    return _titleLabel;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"arrow_right"];
    }
    return _arrowView;
}

@end
