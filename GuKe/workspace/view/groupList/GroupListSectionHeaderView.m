//
//  GroupListSectionHeaderView.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupListSectionHeaderView.h"
#import "WorkGroupListItemView.h"
#import "GroupInfoModel.h"

@interface GroupListSectionHeaderView ()
@property (nonatomic, strong) WorkGroupListItemView *mainView;
@property (nonatomic, copy) GroupListSectionAction action;
@end


@implementation GroupListSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.mainView];
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
            make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
            make.centerY.equalTo(self.contentView);
        }];
        CGFloat r = IPHONE_X_SCALE(33);
        [self.mainView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(r);
            make.centerY.left.equalTo(self.mainView);
        }];
        self.mainView.imageView.clipsToBounds = YES;
        self.mainView.imageView.layer.cornerRadius = r/2.0f;
        
        self.mainView.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        self.mainView.titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
//        [self.mainView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.mainView.imageView);
//        }];
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];

    }
    return self;
}

- (void)configWithData:(GroupInfoModel *)data action:(GroupListSectionAction)action
{
    if (!data) return;
    self.action = [action copy];
    [self.mainView.imageView sd_setImageWithURL:[NSURL URLWithString:data.groupPortrait] placeholderImage:[UIImage imageNamed:@"icon_group"]];
    self.mainView.titleLabel.text = data.groupName;
    self.mainView.subTitleLabel.text = data.countTitle;
}

- (void)tapAction
{
    if (self.action) {
        self.action();
    }
}

- (WorkGroupListItemView *)mainView
{
    if (!_mainView) {
        _mainView = [[WorkGroupListItemView alloc] init];
    }
    return _mainView;
}


@end
