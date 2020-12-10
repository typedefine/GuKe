//
//  GroupListSectionFooterView.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupListSectionFooterView.h"
#import "WorkGroupListItemView.h"

@interface GroupListSectionFooterView ()

@property (nonatomic, strong) WorkGroupListItemView *mainView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *friendsNum;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;


@end

@implementation GroupListSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        CGFloat h = IPHONE_Y_SCALE(30);
       
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.mas_equalTo(IPHONE_X_SCALE(150));
            make.height.mas_equalTo(h);
        }];
        self.bgView.clipsToBounds = YES;
        self.bgView.layer.cornerRadius = h/2.0f;
        
        [self.bgView addSubview:self.mainView];
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgView);
        }];
        
        CGFloat r = IPHONE_X_SCALE(14);
        [self.mainView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(r);
            make.height.mas_equalTo(r);
        }];
        self.mainView.imageView.image = [UIImage imageNamed:@"icon_group_add"];
        
        self.mainView.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        self.mainView.titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        self.mainView.titleLabel.text = @"新申请好友";
        self.mainView.subTitleLabel.textColor = greenC;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.bgView.hidden = YES;
}

- (void)tapAction
{
    if (self.target && self.action && [self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action];
    }
}

- (void)configWithTarget:(id)target action:(SEL)action newFriendsNum:(NSString *)newFriendsNum
{
    self.target = target;
    self.action = action;
    self.friendsNum = newFriendsNum;
    self.bgView.hidden = newFriendsNum.intValue == 0;
}


- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHex:0xE6F6F1];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        _bgView.hidden = YES;
    }
    return _bgView;
}

- (WorkGroupListItemView *)mainView
{
    if (!_mainView) {
        _mainView = [[WorkGroupListItemView alloc] init];
    }
    return _mainView;
}

- (void)setFriendsNum:(NSString *)friendsNum
{
    _friendsNum = friendsNum;
    if (friendsNum.isValidStringValue) {
        self.mainView.subTitleLabel.text = friendsNum;
    }
}


@end
