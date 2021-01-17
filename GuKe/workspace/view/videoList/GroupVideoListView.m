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
#import "GroupVideoFooterView.h"

@interface GroupVideoListView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GroupVideoListViewModel *viewModel;
@property (nonatomic, strong) UIViewController *targetController;
@property (nonatomic, copy) GroupVideoClickedHandler clicked;
@property (nonatomic, copy) void (^ collapseHandler)(void);

@property (nonatomic, strong) UILabel *blankLabel;
@property (nonatomic, strong) GroupVideoFooterView *footerView;

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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.footerView];
    [self.footerView configWithTarget:self action:@selector(collapse)];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(IPHONE_X_SCALE(40));
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    [self addSubview:self.blankLabel];
    [self.blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(IPHONE_X_SCALE(25));
        make.centerX.equalTo(self);
    }];
}

- (void)collapse
{
    if(self.collapseHandler){
        self.collapseHandler();
    }
}

- (void)configWithData:(id)data clicked:(GroupVideoClickedHandler)clicked collapse:(void (^)(void))collapse
{
    self.clicked = [clicked copy];
    self.collapseHandler = [collapse copy];
    [self.viewModel configWithData:data];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
    self.blankLabel.hidden = self.viewModel.items.count > 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GroupVideoCell class]) forIndexPath:indexPath];
    [cell configWithData:self.viewModel.items[indexPath.item]];
    cell.tag = 9999;
    [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
    return cell;
}

- (void)itemClicked:(UITapGestureRecognizer *)tap
{
    if (self.clicked) {
        self.clicked(self.viewModel.items[tap.view.tag-9999].model);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = IPHONE_X_SCALE(10);
        layout.itemSize = CGSizeMake(IPHONE_X_SCALE(150), IPHONE_X_SCALE(85));
        layout.sectionInset = UIEdgeInsetsMake(0, IPHONE_X_SCALE(20), 0, IPHONE_X_SCALE(20));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[GroupVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([GroupVideoCell class])];
        _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
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

- (UILabel *)blankLabel
{
    if (!_blankLabel) {
        _blankLabel = [[UILabel alloc] init];
        _blankLabel.textColor = [UIColor colorWithHex:0x666666];
        _blankLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _blankLabel.text = @"暂无视频";
        _blankLabel.hidden = YES;
    }
    return _blankLabel;
}

- (GroupVideoFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[GroupVideoFooterView alloc] init];
    }
    return _footerView;
}

@end
