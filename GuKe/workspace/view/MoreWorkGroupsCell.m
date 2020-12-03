//
//  MoreWorkGroupsCell.m
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "MoreWorkGroupsCell.h"

@interface MoreWorkGroupsCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MoreWorkGroupsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithHex:0xEDF1F4];
        [self.contentView clipCornerWithCornerRadius:10];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-10);
        }];
        
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(16);
        }];
      
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"icon_more_groups"];
//        _imageView.clipsToBounds = YES;
        
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _titleLabel.textColor = greenC;
        _titleLabel.text = @"查看全部";
    }
    return _titleLabel;
}



@end
