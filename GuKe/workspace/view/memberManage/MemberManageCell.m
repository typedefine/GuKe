//
//  MemberManageCell.m
//  GuKe
//
//  Created by saas on 2020/12/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "MemberManageCell.h"
#import "UserInfoModel.h"

@interface MemberManageCell ()

@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) UILabel *nameLabel;

@end

@implementation MemberManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
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
    self.nameLabel.text = data.doctorName;
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

@end
