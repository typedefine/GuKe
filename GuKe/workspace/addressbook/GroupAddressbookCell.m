//
//  GroupAddressbookCell.m
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupAddressbookCell.h"

@interface GroupAddressbookCell ()

@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *actionLabel;
@property (nonatomic, strong) UIImageView *actionIcon;

@end

@implementation GroupAddressbookCell

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
    
    CGFloat r = IPHONE_X_SCALE(35);
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
        make.left.equalTo(self.portraitView.mas_right).offset(IPHONE_X_SCALE(10));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)configWithData:(UserInfoModel *)data
{
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:data.portrait] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
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
    }
    return _nameLabel;
}

- (UILabel *)markLabel
{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _markLabel.hidden = YES;
    }
    return _markLabel;
}

- (UILabel *)actionLabel
{
    if (!_actionLabel) {
        _actionLabel = [[UILabel alloc] init];
        _actionLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _actionLabel.hidden = YES;
    }
    return _actionLabel;
}

- (UIImageView *)actionIcon
{
    if (!_actionIcon) {
        _actionIcon = [[UIImageView alloc] init];
        _actionIcon.hidden = YES;
    }
    return _actionIcon;
}



@end

