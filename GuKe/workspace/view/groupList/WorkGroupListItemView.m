//
//  WorkGroupListItemView.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupListItemView.h"

@implementation WorkGroupListItemView

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
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    CGFloat r = IPHONE_X_SCALE(20);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(r);
//        make.width.mas_equalTo(IPHONE_X_SCALE(20));
//        make.height.mas_equalTo(IPHONE_X_SCALE(17));
    }];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = r/2.0f;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.imageView.mas_right).offset(IPHONE_X_SCALE(7));
        
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(IPHONE_X_SCALE(14));
        
    }];
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"icon_group"];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.image = [UIImage imageNamed:@"workspace_blank"];
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
        _subTitleLabel.textColor = [UIColor colorWithHex:0xE74F35];
        _subTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
    return _subTitleLabel;
}
@end
