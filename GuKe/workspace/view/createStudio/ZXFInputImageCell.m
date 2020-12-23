//
//  ZXFInputImageCell.m
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFInputImageCell.h"

@interface ZXFInputImageView : UIImageView

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UILabel *indicateLabel;

@end

@implementation ZXFInputImageView

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
    self.userInteractionEnabled = YES;
    [self addSubview:self.addLabel];
    [self addSubview:self.indicateLabel];
    
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
        make.height.mas_equalTo(IPHONE_Y_SCALE(25));
    }];
    [self.indicateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.addLabel.mas_bottom).offset(IPHONE_Y_SCALE(12));
    }];
}

- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    self.addLabel.hidden = imgUrl.isValidStringValue;
    self.indicateLabel.hidden = imgUrl.isValidStringValue;
}

- (UILabel *)addLabel
{
    if (!_addLabel) {
        _addLabel = [[UILabel alloc] init];
        _addLabel.text = @"+";
        _addLabel.textColor = [UIColor colorWithHex:0xD0D0D0];
        _addLabel.font = [UIFont systemFontOfSize:50 weight:UIFontWeightRegular];
    }
    return _addLabel;
}

- (UILabel *)indicateLabel
{
    if (!_indicateLabel) {
        _indicateLabel = [[UILabel alloc] init];
        _indicateLabel.text = @"添加图片";
        _indicateLabel.textColor = [UIColor colorWithHex:0xD0D0D0];
        _indicateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _indicateLabel;
}

@end

@interface ZXFInputImageCell ()

@property (nonatomic, strong) ZXFInputImageView *indicateView;

@end

@implementation ZXFInputImageCell


- (void)setup
{
    [super setup];
//    [self.contentView addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
//        make.top.equalTo(self.contentView).offset(IPHONE_Y_SCALE(5));
//    }];
    
    [self.contentView addSubview:self.indicateView];
    [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(IPHONE_X_SCALE(100));
    }];
}

- (void)pick
{
    
}

- (ZXFInputImageView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[ZXFInputImageView alloc] init];
        _indicateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        [_indicateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pick)]];
    }
    return _indicateView;
}


@end
