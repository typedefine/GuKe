//
//  WorkGroupSupporterView.m
//  GuKe
//
//  Created by yb on 2020/11/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkStudioSupporterView.h"

@interface WorkStudioSupporterView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WorkStudioSupporterView


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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_Y_SCALE(5));
        make.height.mas_equalTo(IPHONE_Y_SCALE(20));
        make.left.equalTo(self);
    }];
    CGFloat r = IPHONE_X_SCALE(50);
    [self addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE_Y_SCALE(10));
        make.left.equalTo(self);
        make.size.mas_equalTo(r);
    }];
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.cornerRadius = r/2.0;
    
    CGFloat btnHeight = IPHONE_Y_SCALE(25), btnWidth = IPHONE_X_SCALE(65);
    [self addSubview:self.detailButton];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoView.mas_right).offset(IPHONE_X_SCALE(10));
        make.bottom.equalTo(self.logoView.mas_bottom);
        make.height.mas_equalTo(btnHeight);
        make.width.mas_equalTo(btnWidth);
    }];
    self.detailButton.clipsToBounds = YES;
    self.detailButton.layer.cornerRadius = btnHeight/2.0f;
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailButton);
        make.bottom.equalTo(self.detailButton.mas_top).offset(-IPHONE_Y_SCALE(9));
    }];
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        _titleLabel.text = @"赞助商";
    }
    return _titleLabel;
}

- (UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _logoView;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _nameLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _nameLabel;
}

- (UIButton *)detailButton
{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.backgroundColor = greenC;
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_detailButton setTitle:@"了解详情" forState:UIControlStateNormal];
    }
    return _detailButton;
}

@end
