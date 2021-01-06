//
//  GroupVideoListView.m
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupVideoListView.h"
#import "GroupVideoListViewModel.h"
#import "GroupVideoCell.h"

@interface GroupVideoListView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GroupVideoListViewModel *viewModel;
@property (nonatomic, strong) UIViewController *targetController;
@property (nonatomic, copy) GroupVideoClickedHandler clicked;

@end

@implementation GroupVideoListView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)configWithData:(id)data clicked:(GroupVideoClickedHandler)clicked
{
    self.clicked = [clicked copy];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GroupVideoCell class]) forIndexPath:indexPath];
    [cell configWithData:self.viewModel.items[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clicked) {
        self.clicked(indexPath.item);
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[GroupVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([GroupVideoCell class])];
    }
    return _collectionView;
}

- (GroupVideoListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[GroupVideoListViewModel alloc] init];
    }
    return _viewModel;
}

@end
