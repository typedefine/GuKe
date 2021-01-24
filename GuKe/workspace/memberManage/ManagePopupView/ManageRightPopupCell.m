//
//  ManageRightPopupCell.m
//  GuKe
//
//  Created by yb on 2021/1/22.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "ManageRightPopupCell.h"
#import "ManageRightPopupCellModel.h"

@interface ManageRightPopupCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectIcon;

@end


@implementation ManageRightPopupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(-30);
    }];
    
    [self.contentView addSubview:self.selectIcon];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(80);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectIcon.image = [UIImage imageNamed:@"选医院"];
    }else{
        self.selectIcon.image = [UIImage imageNamed:@"选医院_未"];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    self.selectIcon.image = [UIImage imageNamed:@"选医院_未"];
}

- (void)configWithData:(ManageRightPopupCellModel *)data
{
    self.titleLabel.text = data.title;
    if (data.alert) {
        self.titleLabel.textColor = [UIColor colorWithHex:0xD83205];
    }
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

- (UIImageView *)selectIcon
{
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc] init];
    }
    return _selectIcon;
}

@end
