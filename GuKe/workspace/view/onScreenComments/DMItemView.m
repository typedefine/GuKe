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
    [self addSubview:self.contentLabel];
//    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self).offset(10);
//    }];
//    [self addSubview:self.contentLabel];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconView.mas_right).offset(2);
//        make.right.equalTo(self).offset(-10);
//        make.centerY.equalTo(self);
//        make.width.mas_equalTo(80);
//    }];
}


- (void)configWithData:(FDanmakuModel *)data
{
    CGFloat h = 25;
    CGFloat x = 10;
    CGFloat w = 0;
    NSString *name = data.name;
    NSString *content = @"";
    if (data.type != 0) {
        self.iconView.hidden = NO;
        [self addSubview:self.iconView];
        if (data.type==1) {
            self.iconView.image = [UIImage imageNamed:@"dm_icon_video"];
            content = [NSString stringWithFormat:@"%@ 分享了一个视频",name];
        }else{
            self.iconView.image = [UIImage imageNamed:@"dm_icon_live"];
            content = [NSString stringWithFormat:@"%@ 分享了一个直播",name];
        }
        CGSize size = self.iconView.image.size;
        self.iconView.frame = CGRectMake(x, (h-size.height)/2.0, size.width, size.height);
        x += self.iconView.frame.size.width + 3;
        w += 15;
    }else{
        content = [NSString stringWithFormat:@"%@：%@",name,data.content];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:greenC} range:NSMakeRange(0, name.length+1)];
    self.contentLabel.attributedText = attributedString;
    
    CGFloat w_c = [Tools sizeOfText:content andMaxSize:CGSizeMake(CGFLOAT_MAX, h) andFont:self.contentLabel.font].width + 5;
    self.contentLabel.frame = CGRectMake(x, (h-20)/2.0, w_c, 20);
    w += w_c + 20;
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
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _contentLabel;
}

@end
