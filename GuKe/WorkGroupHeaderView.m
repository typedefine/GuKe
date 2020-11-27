//
//  WorkGroupHeaderView.m
//  GuKe
//
//  Created by yb on 2020/11/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupHeaderView.h"

@interface WorkGroupHeaderView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WorkGroupHeaderView

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(IPHONE_Y_SCALE(35));
        make.left.right.top.equalTo(self);
    }];
    
    CGFloat r = IPHONE_X_SCALE(65);
    [self addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_Y_SCALE(15));
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(r);
    }];
    self.logoView.clipsToBounds = YES;
    self.logoView.layer.cornerRadius = r/2.0f;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(IPHONE_Y_SCALE(15));
        make.left.equalTo(self.logoView.mas_right).with.offset(IPHONE_X_SCALE(6));
    }];
    
    
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (title.isValidStringValue) {
        self.titleLabel.text = title;
    }
}

- (void)setLogoUrl:(NSString *)logoUrl
{
    _logoUrl = logoUrl;
    if (logoUrl.isValidStringValue) {
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }
}

- (void)configWithData:(id)data
{
    self.titleLabel.text = @"大骨科工作室";
}


- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = greenC;
    }
    return _topView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}

-(UIImageView *)logoView
{
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.contentMode = UIViewContentModeScaleToFill;
    }
    return _logoView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
