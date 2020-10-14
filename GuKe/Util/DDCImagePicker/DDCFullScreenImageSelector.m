//
//  DDCFullScreenImageSelector.m
//  DayDayCook
//
//  Created by Christopher Wood on 11/3/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCFullScreenImageSelector.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DDCImageSelectorCell.h"
#import "GuKeNavigationViewController.h"
#import "FakeNavBar.h"
#import "PGImageUtility.h"
#import "DDCImageModel.h"

#define IMGCELL                   @"IMGCELL"
#define CAMCELL                   @"CAMCELL"
#define TABLECELL                 @"TABLECELL"
#define kMinLineSpacing           5.0
#define kTag     1000

@implementation DDCImageSelectorCachePolicy

- (instancetype)init
{
    if (self = [super init]){
        self.limit = 1;
    }
    return self;
}

- (instancetype)initWithReuseId:(NSString *)ID limit:(NSInteger)limit
{
    if (self = [super init]){
        self.reuseId = ID;
        self.limit = limit;
    }
    return self;
}

@end

@interface DDCFullScreenImageSelector() <FakeNavBarDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    CGFloat           _itemWidth;
    FakeNavBar      * _navBar;
    BOOL            _isShowing;
    BOOL            _isNeedLoad;
}

@property (nonatomic, strong) UICollectionView                          * collectionView;
@property (nonatomic, strong) NSMutableArray<DDCImageModel *>    * totalImageList;
@property (nonatomic) NSInteger                                       totalImageCount;

@property (nonatomic, weak)id<DDCFullScreenImageSelectorDelegate>     delegate;

@property (nonatomic, strong) NSDictionary<NSString *, NSMutableArray<DDCImageModel *> *> *selectedImagesDict;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *>      *limitDict;
//@property (nonatomic, strong) NSMutableArray<DDCImageModel *>            *curSelectedImagesList;
@property (nonatomic, strong) DDCImageSelectorCachePolicy               *curCachePolicy;

@end

@implementation DDCFullScreenImageSelector

@synthesize limitCount = _limitCount;

-(instancetype)init
{
    if (!(self = [super init])) return nil;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    _itemWidth = floor((ScreenWidth-(2*kMinLineSpacing))/3);
    layout.itemSize = CGSizeMake(_itemWidth, _itemWidth);
    layout.minimumLineSpacing = kMinLineSpacing;
    layout.minimumInteritemSpacing = kMinLineSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[DDCImageSelectorCell class] forCellWithReuseIdentifier:IMGCELL];
    [_collectionView registerClass:[DDCImageSelectorCell class] forCellWithReuseIdentifier:CAMCELL];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _navBar = [[FakeNavBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight) title:NSLocalizedString(@"选择图片", @"DDCFullScreenImageSelector") textColor:[UIColor whiteColor]
                                leftButtonImage:[UIImage imageNamed:@"icon_closed"]
                           leftButtonImageColor:nil
                               rightButtonImage:nil
                          rightButtonImageColor:nil
                                       delegate:self];
    [_navBar setRightButtonTitle:NSLocalizedString(@"确定", @"DDCFullScreenImageSelector") rightButtonTextColor:[UIColor whiteColor]];
    _navBar.backgroundColor = greenC;
    _limitCount = 1;
    _selectedImagesDict = [NSMutableDictionary dictionary];
    _limitDict = [NSMutableDictionary dictionary];
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.selectionCachePolicyList = @[[[DDCImageSelectorCachePolicy alloc] initWithReuseId:NSStringFromClass([self class]) limit:1]];
    
    return self;
}

-(instancetype)initWithDelegate:(id<DDCFullScreenImageSelectorDelegate>)delegate
{
    if (self = [self init]){
        self.delegate = delegate;
//        [self.selectedImagesDict setValue:[NSMutableArray<DDCImageModel *> array] forKey:_curCachePolicy.reuseId];
//        [self.limitDict setValue:[NSNumber numberWithInteger:_limitCount] forKey:_curCachePolicy.reuseId];
    }
    return self;
}

-(instancetype)initWithDelegate:(id<DDCFullScreenImageSelectorDelegate>)delegate selectionCachePolicyList:(NSArray<DDCImageSelectorCachePolicy *> *)selectionCachePolicyList
{
    if (self = [self initWithDelegate:delegate]){
        self.selectionCachePolicyList = selectionCachePolicyList;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:_navBar];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(NavBarHeight);
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_isNeedLoad){
        [self getData];
    }
}

-(void)setSelectionCachePolicyList:(NSArray<DDCImageSelectorCachePolicy *> *)selectionCachePolicyList
{
    if (!selectionCachePolicyList || selectionCachePolicyList == _selectionCachePolicyList) return;

    _selectionCachePolicyList = selectionCachePolicyList;

    for (DDCImageSelectorCachePolicy *policy in selectionCachePolicyList) {
        if (![[self.selectedImagesDict allKeys] containsObject:policy.reuseId]) {
            [self.selectedImagesDict setValue:[NSMutableArray<DDCImageModel *> array] forKey:policy.reuseId];
            [self.limitDict setValue:[NSNumber numberWithInteger:policy.limit] forKey:policy.reuseId];
        }
    }
    self.curCachePolicy = selectionCachePolicyList.firstObject;
}

- (void)setCurCachePolicy:(DDCImageSelectorCachePolicy *)curCachePolicy
{
    _curCachePolicy = curCachePolicy;
    if (_curCachePolicy == curCachePolicy || !curCachePolicy) return;
//    self.curSelectedImagesList = self.selectedImagesDict[curCachePolicy.reuseId];
    _limitCount = self.limitDict[curCachePolicy.reuseId].integerValue;
}


- (void)deleteWithCacheImageList:(NSArray<DDCImageModel *> *)cacheImageList
{
    NSMutableArray<DDCImageModel *> *selectList = self.selectedImagesDict[self.curCachePolicy.reuseId];
    if (cacheImageList && cacheImageList.count && selectList && selectList.count) {
        for (DDCImageModel *m in cacheImageList) {
            for (int i=0; i<selectList.count; i++) {
                DDCImageModel *model = selectList[i];
                if (m.tag == model.tag) {
                    [selectList removeObject:model];
                    i--;
                }
            }
            
        }
    }
}

- (void)showWithCache:(DDCImageSelectorCachePolicy *)cache
{
    if(!cache) return;
    self.curCachePolicy = cache;
    [self show];
}

- (void)show
{
    if(_isShowing) return;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _isShowing = YES;
        _isNeedLoad = YES;
        GuKeNavigationViewController *navController = [[GuKeNavigationViewController alloc] initWithRootViewController:self];
        UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
        [root presentViewController:navController animated:YES completion:nil];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)dismiss
{
    if (!_isShowing) return;
    _isShowing = NO;
    _isNeedLoad = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}

//获取相册列表
-(void)getData
{
    _totalImageList = [NSMutableArray array];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status)
        {
            case PHAuthorizationStatusAuthorized:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showHudInView:self.view hint:nil];
                });
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    PHFetchResult * albumResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
                    if (!albumResults.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideHud];
                        });
                    }else{
                        [albumResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj)
                            {
                                DDCImageModel *m = [[DDCImageModel alloc] init];
                                PHAsset * asset = (PHAsset*)obj;
                                m.asset = asset;
                                [_totalImageList addObject:m];
                            }
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideHud];
                            _totalImageList = [NSMutableArray arrayWithArray:[[_totalImageList reverseObjectEnumerator] allObjects]];
                            
                            // 临界情况 - 用户选了一些图片然后打开了相册而删了或多加了一些图片然后再打开了我们app并去选更多图片
                            NSInteger min = 0;
                            NSMutableArray *selectList = self.selectedImagesDict[self.curCachePolicy.reuseId];
                            if(selectList.count > 0){
                                NSInteger t = _totalImageList.count - _totalImageCount;
                                for (DDCImageModel * model in selectList)
                                {
                                    model.tag += t;
                                    if (model.tag >= kTag) {
                                        _totalImageList[model.tag-kTag].tag = model.tag;
                                        _totalImageList[model.tag-kTag].isSelected = YES;
                                    }
                                    min = MIN(min, model.tag);
                                }
                            }
                            _totalImageCount = _totalImageList.count;
                            [_collectionView reloadData];
                            [self setConfirmButton];
                            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:min inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                        });
                    }
       
                });
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"亲，你没有允许日日煮使用你的相册", @"DDCFullScreenImageSelector") message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"好", @"DDCFullScreenImageSelector") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.delegate cancelClickForImageSelector:self];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark-UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalImageList.count + 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item !=0)
    {
        DDCImageSelectorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IMGCELL forIndexPath:indexPath];
        CGSize size = [collectionView layoutAttributesForItemAtIndexPath:indexPath].size;
        __weak typeof(self) weakSelf = self;
        [cell configureCellWithData:self.totalImageList[indexPath.item-1] itemSize:size selectedBlock:^(DDCImageModel *imageModel, UIButton *button) {
            NSMutableArray *selectedList = weakSelf.selectedImagesDict[weakSelf.curCachePolicy.reuseId];
            if (!imageModel.isSelected && selectedList.count == _limitCount)
            {
                [weakSelf.view makeToast:[NSString stringWithFormat:@"你只能选择%ld张图片哦",(long)_limitCount]];
                return;
            }
            
            imageModel.isSelected = button.selected = !button.selected;

            if (imageModel.isSelected) {
                imageModel.tag = indexPath.item-1 + kTag;
                [selectedList addObject:imageModel];
            }else{
                for (int i=0; i<selectedList.count; i++) {
                    DDCImageModel *model = selectedList[i];
                    if (model.tag == imageModel.tag){
                        [selectedList removeObjectAtIndex:i];
                        i--;
                    }
                }
            }
            [self setConfirmButton];
        }];
        return cell;
    }
    else
    {
        DDCImageSelectorCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CAMCELL forIndexPath:indexPath];
        [cell configureCellForCamera];
        return cell;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0)
    {
//        PHAsset *asset = _totalImageList[indexPath.row - 1].asset;
//        if ([_delegate respondsToSelector:@selector(imageSelector:everyImageClick:index:)])
//        {
//            [_delegate imageSelector:self everyImageClick:asset index:indexPath.row - 1];
//        }
        _isNeedLoad = NO;
        DDCImageViewerController * viewerController = [[DDCImageViewerController alloc] init];
        viewerController.albumImageAssetArray = self.totalImageList;
        viewerController.currentIndex = indexPath.row - 1;
        [self.navigationController pushViewController:viewerController animated:YES];
    }
    else
    {
        if (self.selectedImagesDict[self.curCachePolicy.reuseId].count == _limitCount)
        {
            [self.view  makeToast:[NSString stringWithFormat:@"你只能选择%ld张图片哦", (long)_limitCount]];
            return;
        }
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"亲，您的设备不支持照相机功能", @"DDCFullScreenImageSelector") message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"DDCFullScreenImageSelector") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

//-(void)selectBtnClick:(UIButton*)btn
//{
//    if (!btn.selected && _selectedImagesList.count == _pictureLimit)
//    {
//        [self.view makeToast:[NSString stringWithFormat:NSLocalizedString(@"你只能选择%ld张图片哦", @"DDCFullScreenImageSelector"), _pictureLimit]];
//        return;
//    }
//
//    btn.selected = !btn.selected;
//    DDCImageSelectorCell * cell = (DDCImageSelectorCell*)[[btn superview] superview];
//    NSIndexPath * indexPath = [_collectionView indexPathForCell:cell];
//    PHAsset * selectedAsset = _totalImageList[indexPath.item - 1].asset;
//
//    if (btn.selected)
//    {
//        [_selectedImagesList addObject:[DDCImageModel modelWithImage:nil asset:selectedAsset tag:[NSString stringWithFormat:@"%ld", indexPath.item]]];
//    }
//    else
//    {
//        for (int i=0; i<_selectedImagesList.count; i++)
//        {
//            DDCImageModel * model = _selectedImagesList[i];
//            if ([model.tag isEqualToString:[NSString stringWithFormat:@"%ld", indexPath.item]])
//            {
//                [_selectedImagesList removeObject:model];
//            }
//        }
//    }
//
//    [self setConfirmButton];
//}

-(void)setConfirmButton
{
    if (self.selectedImagesDict[self.curCachePolicy.reuseId].count == 0)
    {
        [_navBar setRightButtonTitle:NSLocalizedString(@"确定", @"DDCFullScreenImageSelector") rightButtonTextColor:nil];
    }
    else
    {
        [_navBar setRightButtonTitle:[NSString stringWithFormat:@"确定 (%lu)", (unsigned long)self.selectedImagesDict[self.curCachePolicy.reuseId].count] rightButtonTextColor:nil];
    }
}

-(void)didTapRightBarButton
{
    if(self.selectedImagesDict[self.curCachePolicy.reuseId].count == 0 ){
        [self.view makeDDCToast:@"请选择图片!" image:[UIImage imageNamed:@"icon_warning_red"] imagePosition:ImageTop];
        return;
    }
    [self dismiss];
    if (self.delegate && [_delegate respondsToSelector:@selector(imageSelector:didSelectWithImageList:)])
    {
        [_delegate imageSelector:self didSelectWithImageList:self.selectedImagesDict[self.curCachePolicy.reuseId]];
    }
}

-(void)didTapLeftBarButton
{
    [self dismiss];
    if (self.delegate && [_delegate respondsToSelector:@selector(cancelClickForImageSelector:)])
    {
        [_delegate cancelClickForImageSelector:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _isNeedLoad = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage] && [info[UIImagePickerControllerOriginalImage] isKindOfClass:[UIImage class]])
        {
            UIImage *image = (UIImage*)info[UIImagePickerControllerOriginalImage];
            image = [PGImageUtility fixImageOrientation:image];
            //            image = [PGImageUtility zoomImage:image withMaxPixels:120 * 10000];
            
            //保存到系统相册
            NSLog(@"开始保存到系统相册");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            });
//            DDCImageModel *m = [DDCImageModel modelWithImage:image asset:nil tag:nil];
            DDCImageModel *m = [[DDCImageModel alloc] init];
            m.image = image;
//            m.isCompletedDownload = image != nil;
            m.isSelected = YES;
            m.tag = kTag;
            [_totalImageList insertObject:m atIndex:0];
            _totalImageCount = _totalImageList.count;
            [_collectionView reloadData];
            NSMutableArray *selectList = self.selectedImagesDict[self.curCachePolicy.reuseId];
            for (DDCImageModel *model in selectList) {
                model.tag += 1;
            }
            [selectList insertObject:m atIndex:0];
            
            [self setConfirmButton];
        }
    }];
}

@end
