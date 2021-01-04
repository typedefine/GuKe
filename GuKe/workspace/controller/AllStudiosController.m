//
//  AllGroupsController.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "AllStudiosController.h"
#import "AllStudiosHeaderView.h"
#import "WorkStudioItemCell.h"
#import "WorkStudioInfoController.h"

@interface AllStudiosController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<GroupInfoModel *> *groups;

@end

@implementation AllStudiosController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"全部工作室";
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadData];
}

- (void)loadData
{
    NSArray *ids = @[@"1", @"2"];
    NSArray *titles = @[@"大骨科工作室", @"王医生大骨科工作室"];
    NSArray *imgs = @[
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1363512782,2335530027&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3695259271,1715923868&fm=26&gp=0.jpg",
    ];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:ids.count];
    for (int i=0; i<ids.count; i++) {
        GroupInfoModel *itemModel = [[GroupInfoModel alloc] init];
        itemModel.groupId = [ids[i] integerValue];
        itemModel.groupName = titles[i];
        itemModel.groupPortrait = imgs[i];
        [items addObject:itemModel];
    }
    self.groups = [items copy];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = IPHONE_X_SCALE(10);
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.estimatedItemSize = CGSizeMake(IPHONE_X_SCALE(105), IPHONE_Y_SCALE(150));
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 50);
        layout.footerReferenceSize = CGSizeZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.allowsSelection = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[AllStudiosHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AllStudiosHeaderView class])];
        [_collectionView registerClass:[WorkStudioItemCell class] forCellWithReuseIdentifier:NSStringFromClass([WorkStudioItemCell class])];
    }
    return _collectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AllStudiosHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AllStudiosHeaderView class]) forIndexPath:indexPath];
        header.searchBar.delegate = self;
        return header;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WorkStudioItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WorkStudioItemCell class]) forIndexPath:indexPath];
    [cell configCellWithData:self.groups[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfoModel *model = self.groups[indexPath.item];
    WorkStudioInfoController *vc = [[WorkStudioInfoController alloc] init];
    vc.groupInfo = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}


@end
