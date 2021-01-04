//
//  GroupManageCell.m
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupManageOperationCell.h"
#import "GroupOperationItemModel.h"

@interface GroupManageOperationCell ()

@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) UILabel *nameLabel;

@end

@implementation GroupManageOperationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat r = IPHONE_X_SCALE(16);
    [self.contentView addSubview:self.portraitView];
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(r);
    }];
    self.portraitView.clipsToBounds = YES;
    self.portraitView.layer.cornerRadius = r/2.0f;
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitView.mas_right).offset(IPHONE_X_SCALE(12));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configWithData:(GroupOperationItemModel *)data
{
    UIImage *image = [UIImage imageNamed:data.imagePath];
    self.portraitView.image = image;
    [self.portraitView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    self.nameLabel.text = data.name;
}


- (UIImageView *)portraitView
{
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
    }
    return _portraitView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _nameLabel;
}

@end
