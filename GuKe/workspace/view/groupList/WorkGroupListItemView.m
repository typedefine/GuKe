//
//  WorkGroupListItemView.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupListItemView.h"

@implementation WorkGroupListItemView

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
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
