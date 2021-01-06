//
//  GroupVideoCell.m
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupVideoCell.h"
#import "GroupVideoCellModel.h"

@interface GroupVideoCell ()

@property(nonatomic, strong) UIImageView *coverView;
@property(nonatomic, strong) UIImageView *iconView;

@end

@implementation GroupVideoCell

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
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(40);
    }];
}

- (void)configWithData:(GroupVideoCellModel *)data
{
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl] placeholderImage:[UIImage imageNamed:@"default_img"]];
}

- (UIImageView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.clipsToBounds = YES;
        _coverView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"group_video_selected"];
    }
    return _iconView;
}

@end
