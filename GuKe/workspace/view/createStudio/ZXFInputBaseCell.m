//
//  ZXFInputBaseCell.m
//  GuKe
//
//  Created by saas on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFInputBaseCell.h"

@implementation ZXFInputBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.height.mas_equalTo(20);
    }];
}

//- (void)configWithCellModel:(ZXFInputCellModel *)cellModel
//{
//}

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
