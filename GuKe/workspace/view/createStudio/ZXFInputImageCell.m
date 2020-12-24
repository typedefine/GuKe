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

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZXFInputImageView *indicateView;
@property (nonatomic, copy) void (^ pickAction)(id data);

@end

@implementation ZXFInputImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.top.equalTo(self.contentView).offset(IPHONE_X_SCALE(5));
    }];
    
    [self.contentView addSubview:self.indicateView];
    [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(IPHONE_X_SCALE(15));
        make.size.mas_equalTo(IPHONE_X_SCALE(100));
    }];
}

- (void)configureWithTitle:(NSString *)title indicate:(NSString *)indicate imgUrl:(NSString *)imgUrl completion:(void (^)(id data))completion
{
    if (title.isValidStringValue) {
        self.titleLabel.text = title;
        CGFloat w = [Tools sizeOfText:title andMaxSize:CGSizeMake(CGFLOAT_MAX, 20) andFont:self.titleLabel.font].width + 5;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(IPHONE_X_SCALE(5));
            make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
            make.width.mas_equalTo(w);
        }];
    }
    self.indicateView.indicateLabel.text = indicate;
    self.indicateView.imgUrl = imgUrl;
    self.pickAction = [completion copy];
}


- (void)pick
{
    if (self.pickAction) {
        self.pickAction(nil);
    }
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}



@end
