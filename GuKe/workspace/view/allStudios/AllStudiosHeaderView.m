//
//  AllGroupsHeaderView.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "AllStudiosHeaderView.h"

@interface AllStudiosHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation AllStudiosHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(IPHONE_X_SCALE(20));
        make.centerY.equalTo(self);
    }];
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(IPHONE_X_SCALE(180));
        make.right.equalTo(self).offset(-IPHONE_X_SCALE(30));
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        _titleLabel.text = @"工作室";
    }
    return _titleLabel;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索工作室";
        _searchBar.tintColor = greenC;
//        _searchBar.contentMode = UIViewContentModeCenter;
//        _searchBar.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return _searchBar;
}


@end
