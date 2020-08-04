//
//  PatientRecordInfoManageController.m
//  GuKe
//
//  Created by 莹宝 on 2020/7/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientRecordInfoManageController.h"
#import "PatientRecordInfoManageModel.h"
#import "PatientRecordBookCell.h"
#import "PatientRecordFitMentionCell.h"
#import "PatientRecordInfoManageCell.h"
#import "PatientRecordInfoManageHeaderView.h"

@interface PatientRecordInfoManageController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) PatientRecordInfoManageModel *viewModel;

@end

@implementation PatientRecordInfoManageController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.viewModel configureWithData:[[NSObject alloc] init]];
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.collection reloadData];
}



//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return  UIEdgeInsetsZero;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return  CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.numberOfSection;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel sizeForItemAtSection:indexPath.section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        PatientRecordInfoManageHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PatientRecordInfoManageHeaderView class]) forIndexPath:indexPath];
        headerView.title = [self.viewModel titleForSection:indexPath.section];
        return headerView;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowAtSection:section];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            PatientRecordFitMentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PatientRecordFitMentionCell class]) forIndexPath:indexPath];
            return cell;
        }
            
        case 1:
        {
            PatientRecordInfoManageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PatientRecordInfoManageCell class]) forIndexPath:indexPath];
            PatientRecordInfoManageSectionModel *sectionModel = (PatientRecordInfoManageSectionModel *)[_viewModel sectionModel:indexPath.section];
            [cell configureWithData: sectionModel.cellModelList[indexPath.item]];
            return cell;
        }
    
            
        default:
        {
            PatientRecordBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PatientRecordBookCell class]) forIndexPath:indexPath];
            PatientRecordBookSectionModel *sectionModel = (PatientRecordBookSectionModel *)[_viewModel sectionModel:indexPath.section];
            [cell configureWithData: sectionModel.cellModelList[indexPath.item]];
            return cell;
        }
    }
   
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    
}


- (UICollectionView *)collection
{
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 30);
        layout.footerReferenceSize = CGSizeMake(ScreenWidth, 20);
        layout.sectionHeadersPinToVisibleBounds = YES;
//        layout.sectionInset = UIEdgeInsetsZero;
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.prefetchingEnabled = YES;
        _collection.allowsSelection = NO;
        [_collection registerClass:[PatientRecordBookCell class] forCellWithReuseIdentifier:NSStringFromClass([PatientRecordBookCell class])];
        [_collection registerClass:[PatientRecordFitMentionCell class] forCellWithReuseIdentifier:NSStringFromClass([PatientRecordFitMentionCell class])];
        [_collection registerClass:[PatientRecordInfoManageCell class] forCellWithReuseIdentifier:NSStringFromClass([PatientRecordInfoManageCell class])];
        [_collection registerClass:[PatientRecordInfoManageHeaderView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PatientRecordInfoManageHeaderView class])];
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.prefetchDataSource = self;
    }
    return _collection;
}

- (PatientRecordInfoManageModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[PatientRecordInfoManageModel alloc] init];
    }
    return _viewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
