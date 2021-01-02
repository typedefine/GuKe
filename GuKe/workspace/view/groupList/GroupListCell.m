//
//  GroupListCell.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupListCell.h"
#import "WorkGroupListItemView.h"
#import "GroupInfoModel.h"

@interface GroupListCell ()

@property (nonatomic, strong) WorkGroupListItemView *mainView;

@end

@implementation GroupListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.mainView];
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
            make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configWithData:(GroupInfoModel *)data
{
    if (!data) return;
    [self.mainView.imageView sd_setImageWithURL:[NSURL URLWithString:data.groupPortrait] placeholderImage:[UIImage imageNamed:@"icon_group"]];
    self.mainView.titleLabel.text = data.groupName;
    self.mainView.subTitleLabel.text = data.countTitle;
}

- (WorkGroupListItemView *)mainView
{
    if (!_mainView) {
        _mainView = [[WorkGroupListItemView alloc] init];
    }
    return _mainView;
}

@end
