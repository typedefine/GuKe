//
//  WorkGroupsCell.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceFooter.h"
#import "WorkGroupItemCell.h"
#import "MoreWorkGroupsCell.h"

@interface WorkSpaceFooter ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic, strong) NSArray<GroupInfoModel *> *groups;

@end

@implementation WorkSpaceFooter


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
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_Y_SCALE(15));
        make.height.mas_equalTo(IPHONE_Y_SCALE(45));
        make.left.right.mas_equalTo(self);
    }];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(IPHONE_Y_SCALE(160));
    }];
}

- (WorkGroupsTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WorkGroupsTitleView alloc] init];
    }
    return _titleView;
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
        [_collectionView registerClass:[WorkGroupItemCell class] forCellWithReuseIdentifier:NSStringFromClass([WorkGroupItemCell class])];
        [_collectionView registerClass:[MoreWorkGroupsCell class] forCellWithReuseIdentifier:NSStringFromClass([MoreWorkGroupsCell class])];
    }
    return _collectionView;
}

- (void)configureWithTarget:(id)target action:(SEL)action groups:(NSArray<GroupInfoModel *> *)groups
{
    self.target = target;
    self.action = action;
    self.groups = groups;
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
    return self.groups.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.groups.count) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MoreWorkGroupsCell class]) forIndexPath:indexPath];
    }
    WorkGroupItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WorkGroupItemCell class]) forIndexPath:indexPath];
    [cell configCellWithData:self.groups[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.target || !self.action) return;
    
        if ([self.target respondsToSelector:self.action]) {
            NSString *Id = @"all";
            if (indexPath.item < self.groups.count) {
                Id = @(self.groups[indexPath.item].groupid).stringValue;
            }
            [self.target performSelector:self.action withObject:Id];
        }
    
}



@end
