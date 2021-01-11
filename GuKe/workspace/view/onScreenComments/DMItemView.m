//
//  DMItemView.m
//  GuKe
//
//  Created by yb on 2021/1/10.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "DMItemView.h"
#import "FDanmakuModel.h"

@implementation DMItemView

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
    self.backgroundColor = [UIColor colorWithHex:0x242C28 alpha:0.6];
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(2);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
}


- (void)configWithData:(FDanmakuModel *)data
{
    NSString *name = data.name;
    NSString *content = @"";
    if (data.type != 0) {
        self.iconView.hidden = NO;
        if (data.type==1) {
            self.iconView.image = [UIImage imageNamed:@"dm_icon_video"];
            content = [NSString stringWithFormat:@"%@ 分享了一个视频",name];
        }else{
            self.iconView.image = [UIImage imageNamed:@"dm_icon_live"];
            content = [NSString stringWithFormat:@"%@ 分享了一个直播",name];
        }
    }else{
        content = [NSString stringWithFormat:@"%@：%@",name,data.content];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:greenC} range:NSMakeRange(0, name.length+1)];
    self.contentLabel.attributedText = attributedString;
    
    CGFloat h = 25;
    CGFloat w = [Tools sizeOfText:content andMaxSize:CGSizeMake(CGFLOAT_MAX, h) andFont:self.contentLabel.font].width + 2;
    if (data.type > 0) {
        w += self.iconView.image.size.width+2;
        w += 20;
    }else{
        w += 10;
    }
    self.bounds = CGRectMake(0, 0, w, h);
    self.clipsToBounds = YES;
    self.layer.cornerRadius = h/2.0;
}


- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.hidden = YES;
    }
    return _iconView;
}



- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _contentLabel;
}

@end
