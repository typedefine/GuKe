//
//  GroupMemberView.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupMembersView.h"
#import "UserInfoModel.h"
#import "GroupMemberCell.h"
#import "MoreGroupMemberCell.h"

@interface GroupMembersView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@end

@implementation GroupMembersView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_Y_SCALE(15));
        make.height.mas_equalTo(IPHONE_Y_SCALE(20));
        make.left.right.mas_equalTo(self);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE_Y_SCALE(15));
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE_Y_SCALE(25));
//        make.height.mas_equalTo(IPHONE_Y_SCALE(160));
    }];
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//
//}


- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}



- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = IPHONE_X_SCALE(10);
//        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        layout.estimatedItemSize = CGSizeMake(IPHONE_X_SCALE(105), IPHONE_Y_SCALE(150));
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.allowsSelection = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[GroupMemberCell class] forCellWithReuseIdentifier:NSStringFromClass([GroupMemberCell class])];
        [_collectionView registerClass:[MoreGroupMemberCell class] forCellWithReuseIdentifier:NSStringFromClass([MoreGroupMemberCell class])];
    }
    return _collectionView;
}

- (void)configureWithTarget:(id)target action:(SEL)action members:(NSArray<UserInfoModel *> *)members
{
    CGRect f = self.bounds;
    self.bounds = f;
    self.target = target;
    self.action = action;
    self.members = members;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.members.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.members.count) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MoreGroupMemberCell class]) forIndexPath:indexPath];
    }
    GroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GroupMemberCell class]) forIndexPath:indexPath];
//    [cell configCellWithData:self.members[indexPath.item]];
    [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:self.members[indexPath.item].portrait] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.target || !self.action) return;
    
    if ([self.target respondsToSelector:self.action]) {
        NSString *Id = @"all";
        if (indexPath.item < self.members.count) {
            Id = self.members[indexPath.item].phone;
        }
        [self.target performSelector:self.action withObject:Id];
    }
}

@end
