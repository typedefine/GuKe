//
//  PatientRecordInfoManageController.m
//  GuKe
//
//  Created by 莹宝 on 2020/7/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientInfoManageController.h"
#import "PatientInfoManagePageModel.h"
#import "PatientBookInfoStateCell.h"
#import "PatientFitMentionCell.h"
#import "PatientInfoManageCell.h"
#import "PatientInfoManageHeaderView.h"

@interface PatientInfoManageController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, UIScrollViewDelegate>

//@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) PatientInfoManagePageModel *viewModel;

@end

@implementation PatientInfoManageController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /*
    CGFloat w = 70.0f , x = w/2.0 + (ScreenWidth-3*w)/4.0f, bottomMargin = 20+TabbarAddHeight;
    [self.view addSubview:self.previewButton];
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bottomMargin);
        make.centerX.equalTo(self.view.mas_left).offset(x);
        make.width.mas_equalTo(w);
    }];
    [self.previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    self.previewButton.hidden = YES;
    */
    CGFloat w = 70.0f , bottomMargin = 20+TabbarAddHeight;

    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bottomMargin);
        make.right.equalTo(self.view.mas_centerX).offset(-40);
        make.width.mas_equalTo(w);
    }];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bottomMargin);
        make.left.equalTo(self.view.mas_centerX).offset(40);
        make.width.mas_equalTo(w);
    }];
    [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collection reloadData];
    
    [self getData];
}

- (void)getData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_info];
    NSArray *keysArray = @[@"hospid",@"sessionid"];
    NSArray *valueArray = @[self.viewModel.hospid, self.viewModel.sessionid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"病例--信息管理%@",data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            [self.viewModel configureWithData:dict[@"data"]];
        }
        [self hideHud];
        [self.collection reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"病例--信息管理error:%@",error);
    }];
    
}

/*
- (void)preview
{
    
}
*/

- (void)save
{
    if (![self.viewModel isInfoChanged]) {
        [self showHint:@"无任何修改，无需保存"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_info_manage];
    PatientInfoManageSectionModel *sectionModel = (PatientInfoManageSectionModel *)[self.viewModel sectionModel:1];
    NSMutableDictionary *para = [@{
        @"hospid": self.viewModel.hospid,
        @"sessionid": self.viewModel.sessionid,
        @"hide_visit": sectionModel.cellModelList[0].select?@(1):@(0),
        @"hide_surgical": sectionModel.cellModelList[1].select?@(1):@(0),
        @"hide_revisit": sectionModel.cellModelList[2].select?@(1):@(0)
    } mutableCopy];
    NSString *tips = ((PatienFitMentionSectionModel *)[self.viewModel sectionModel:0]).content;
    if (tips.isValidStringValue) {
        para[@"doctor_tips"] = tips;
    }
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        NSLog(@"病例--信息管理-修改信息%@",data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            [self showHint:@"保存成功"];
//            [self.viewModel configureWithData:dict[@"data"]];
        }
        [self hideHud];
        [self.collection reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"病例--信息管理-修改信息error:%@",error);
    }];
}

- (void)cancel
{
    [self.viewModel reset];
    [self.collection reloadData];
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
        PatientInfoManageHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PatientInfoManageHeaderView class]) forIndexPath:indexPath];
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
            PatientFitMentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PatientFitMentionCell class]) forIndexPath:indexPath];
            __block PatienFitMentionSectionModel *sectionModel = (PatienFitMentionSectionModel *)[_viewModel sectionModel:indexPath.section];
            [cell configureCellWithData:sectionModel.content input:^(NSString * _Nonnull text) {
                sectionModel.content = text;
            }];
            return cell;
        }
            
        case 1:
        {
            PatientInfoManageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PatientInfoManageCell class]) forIndexPath:indexPath];
            PatientInfoManageSectionModel *sectionModel = (PatientInfoManageSectionModel *)[_viewModel sectionModel:indexPath.section];
            [cell configureWithData: sectionModel.cellModelList[indexPath.item]];
            return cell;
        }
    
            
        default:
        {
            PatientBookInfoStateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PatientBookInfoStateCell class]) forIndexPath:indexPath];
            PatientBookSectionModel *sectionModel = (PatientBookSectionModel *)[_viewModel sectionModel:indexPath.section];
            [cell configureWithData: sectionModel.cellModelList[indexPath.item]];
            return cell;
        }
    }
   
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}


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
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 44);
        layout.footerReferenceSize = CGSizeMake(ScreenWidth, 15);
        layout.sectionHeadersPinToVisibleBounds = YES;
//        layout.sectionInset = UIEdgeInsetsZero;
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.prefetchingEnabled = YES;
        _collection.allowsSelection = NO;
        _collection.alwaysBounceVertical = YES;
        _collection.alwaysBounceHorizontal = NO;
        [_collection registerClass:[PatientBookInfoStateCell class] forCellWithReuseIdentifier:NSStringFromClass([PatientBookInfoStateCell class])];
        [_collection registerClass:[PatientFitMentionCell class] forCellWithReuseIdentifier:NSStringFromClass([PatientFitMentionCell class])];
        [_collection registerClass:[PatientInfoManageCell class] forCellWithReuseIdentifier:NSStringFromClass([PatientInfoManageCell class])];
        [_collection registerClass:[PatientInfoManageHeaderView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PatientInfoManageHeaderView class])];
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.prefetchDataSource = self;
        _collection.allowsSelection = NO;
    }
    return _collection;
}

- (PatientInfoManagePageModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[PatientInfoManagePageModel alloc] init];
        NSString *hopitalId = [[NSUserDefaults standardUserDefaults]objectForKey:@"hospitalnumbar"];
        _viewModel.hospid = hopitalId;
        _viewModel.sessionid = sessionIding;
    }
    return _viewModel;
}

//- (UIButton *)previewButton
//{
//    if (!_previewButton) {
//        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _previewButton.backgroundColor = [UIColor whiteColor];
//        _previewButton.layer.borderWidth = 1.0;
//        _previewButton.layer.borderColor = SetColor(0x666666).CGColor;
//        _previewButton.layer.masksToBounds = YES;
//        _previewButton.layer.cornerRadius = 5.0;
//        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
//        [_previewButton setTitleColor:titColor forState:UIControlStateNormal];
//        _previewButton.titleLabel.font = Font14;
//    }
//    return _previewButton;
//}


- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = [UIColor whiteColor];
        _saveButton.layer.borderWidth = 1.0;
        _saveButton.layer.borderColor = SetColor(0x666666).CGColor;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.layer.cornerRadius = 5.0;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:titColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = Font14;
    }
    return _saveButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.layer.borderWidth = 1.0;
        _cancelButton.layer.borderColor = SetColor(0x666666).CGColor;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 5.0;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:titColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = Font14;
    }
    return _cancelButton;
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
