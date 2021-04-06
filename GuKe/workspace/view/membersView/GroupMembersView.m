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
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic) id target;
//@property (nonatomic) SEL action;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@end

@implementation GroupMembersView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (instancetype)init
//{
//    if (self = [super init]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    if (self = [super initWithCoder:coder]) {
//        [self setup];
//    }
//    return self;
//}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    
    if (_titleLabel) {
        [_titleLabel removeShadow];
    }
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_Y_SCALE(5));
        make.height.mas_equalTo(IPHONE_Y_SCALE(20));
        make.left.equalTo(self);
    }];
    
    if (_collectionView) {
        [_collectionView removeShadow];
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE_Y_SCALE(20));
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE_Y_SCALE(25));
//        make.height.mas_equalTo(IPHONE_Y_SCALE(140));
    }];
    
}

//- (void)setDelegate:(id<GroupMembersViewDelegate>)delegate
//{
//    _delegate = delegate;
//    if (!delegate) return;
//    
//    self.members = [self.delegate membersInView:self];
//    
//    if ([self.delegate respondsToSelector:@selector(titleInMemberView:)]) {
//        self.titleLabel.text = [self.delegate titleInMemberView:self];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingInMemberView:)]) {
//        self.layout.minimumLineSpacing = [self.delegate minimumLineSpacingInMemberView:self];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingInMemberView:)]) {
//        self.layout.minimumInteritemSpacing = [self.delegate minimumInteritemSpacingInMemberView:self];
//    }
//    
//    if ([self.delegate respondsToSelector:@selector(itemSizeInMemberView:)]) {
//        self.layout.itemSize = [self.delegate itemSizeInMemberView:self];
//    }
//    
//    [self setup];
//    
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView reloadData];
//    
//}


//- (void)setTitle:(NSString *)title
//{
//    self.titleLabel.text = title;
//}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
        _titleLabel.text = @"工作室成员";
    }
    return _titleLabel;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = IPHONE_Y_SCALE(19);
        _layout.minimumInteritemSpacing = IPHONE_X_SCALE(25);
//        _layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        _layout.estimatedItemSize = CGSizeMake(IPHONE_X_SCALE(35), IPHONE_X_SCALE(35));
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.allowsSelection = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[GroupMemberCell class] forCellWithReuseIdentifier:NSStringFromClass([GroupMemberCell class])];
        [_collectionView registerClass:[MoreGroupMemberCell class] forCellWithReuseIdentifier:NSStringFromClass([MoreGroupMemberCell class])];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

//- (void)configureWithTarget:(id)target action:(SEL)action members:(NSArray<UserInfoModel *> *)members
//{
//    self.target = target;
//    self.action = action;
//    self.members = members;
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView reloadData];
//}
- (void)reloadData
{
    if (!self.delegate) return;
    
    
    
    self.members = [self.delegate membersInView:self];
    
    if ([self.delegate respondsToSelector:@selector(titleInMemberView:)]) {
        self.titleLabel.text = [self.delegate titleInMemberView:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingInMemberView:)]) {
        self.layout.minimumLineSpacing = [self.delegate minimumLineSpacingInMemberView:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingInMemberView:)]) {
        self.layout.minimumInteritemSpacing = [self.delegate minimumInteritemSpacingInMemberView:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(itemSizeInMemberView:)]) {
        self.layout.itemSize = [self.delegate itemSizeInMemberView:self];
    }
    
    [self setup];
    
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
    NSString *imgUrlStr = self.members[indexPath.item].portrait;
    [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(memberView:didSelectAtIndex:)]) {
        [self.delegate memberView:self didSelectAtIndex:indexPath.item];
    }
    
//    if (!self.target || !self.action) return;
//
//    if ([self.target respondsToSelector:self.action]) {
//        NSString *Id = @"all";
//        if (indexPath.item < self.members.count) {
//            Id = self.members[indexPath.item].phone;
//        }
//        [self.target performSelector:self.action withObject:Id];
//    }
}

@end
