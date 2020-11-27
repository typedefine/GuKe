//
//  WorkSpaceHeaderView.m
//  GuKe
//
//  Created by yb on 2020/11/25.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceHeaderView.h"

@interface WorkSpaceHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *coverIV;

@end

@implementation WorkSpaceHeaderView



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
    self.clipsToBounds = YES;
    CGFloat sidePadding = IPHONE_X_SCALE(20);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_Y_SCALE(25));
        make.left.equalTo(self).with.offset(sidePadding);
        make.height.mas_equalTo(IPHONE_Y_SCALE(20));
        
    }];
    self.titleLabel.text = @"骨先生工作站";
    
    [self addSubview:self.coverIV];
    
    CGFloat w = ScreenWidth - sidePadding * 2;
    CGFloat h = IPHONE_Y_SCALE(140);//(140.0/335.0) * w;
//    self.coverIV.frame = CGRectMake(sidePadding, IPHONE_Y_SCALE(5), w, h);
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE_Y_SCALE(15));
        make.height.mas_equalTo(h);
        make.width.mas_equalTo(w);
    }];
    self.coverIV.clipsToBounds = YES;
    self.coverIV.layer.cornerRadius = 5;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    CGRect f = self.coverIV.bounds;
//    f.size.height += 10;
//    self.frame = f;
//}


- (void)setCoverImgUrl:(NSString *)coverImgUrl
{
    if (coverImgUrl.isValidStringValue) {
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:coverImgUrl] placeholderImage:[UIImage imageNamed:@"灰_bg"]];
    }
}

- (UIImageView *)coverIV
{
    if (!_coverIV) {
        _coverIV = [[UIImageView alloc] init];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverIV;
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


@end
