//
//  WorkSpaceBlankView.m
//  GuKe
//
//  Created by yb on 2020/12/3.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceBlankView.h"

@interface WorkSpaceBlankView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation WorkSpaceBlankView

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
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-IPHONE_Y_SCALE(80));
        make.width.mas_equalTo(IPHONE_X_SCALE(185));
        make.height.mas_equalTo(IPHONE_X_SCALE(163));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(IPHONE_Y_SCALE(20));
        make.height.mas_equalTo(IPHONE_Y_SCALE(20));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE_Y_SCALE(15));
        make.height.mas_equalTo(IPHONE_Y_SCALE(15));
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"workspace_blank"];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithHex:0x8C8C8C];
        _subTitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    }
    return _subTitleLabel;
}

- (void)setTitle:(NSString *)title
{
    if (title.isValidStringValue) {
        self.titleLabel.text = title;
    }
}

- (void)setSubTitle:(NSString *)subTitle
{
    if (subTitle.isValidStringValue) {
        self.subTitleLabel.text = subTitle;
    }
}

@end
