//
//  DDCImageViewerController.m
//  DayDayCook
//
//  Created by Christopher Wood on 11/4/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageViewerController.h"
#import "DDCImageViewerCell.h"
#import "FakeNavBar.h"
#import "DDCImageModel.h"

#define IMAGECELL                                  @"IMAGECELL"
#define kCollectionViewMinLineSpacing              10.0
#define kCollectionViewMinItemSpacing              10.0


@interface DDCImageViewerController()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, FakeNavBarDelegate>
{
    UICollectionView * _imageCollectionView;
    FakeNavBar       * _navBar;
}

@end

@implementation DDCImageViewerController

-(instancetype)init
{
    if (!(self = [super init])) return nil;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(ScreenWidth-kCollectionViewMinItemSpacing, ScreenHeight-NavBarHeight);
//    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    layout.minimumInteritemSpacing = kCollectionViewMinItemSpacing;
    layout.minimumLineSpacing = kCollectionViewMinLineSpacing;
    
    _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_imageCollectionView registerClass:[DDCImageViewerCell class] forCellWithReuseIdentifier:IMAGECELL];
    _imageCollectionView.pagingEnabled = YES;
    _imageCollectionView.showsVerticalScrollIndicator = NO;
    _imageCollectionView.showsHorizontalScrollIndicator = NO;
    _imageCollectionView.delegate = self;
    _imageCollectionView.dataSource = self;
    
    _navBar = [[FakeNavBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)
                                          title:@""
                                      textColor:[UIColor whiteColor]
                                leftButtonImage:[[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                           leftButtonImageColor:[UIColor whiteColor]
                               rightButtonImage:nil
                          rightButtonImageColor:nil
                                       delegate:self];
    
    _navBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    _navBar.hideBottomLine = YES;
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_imageCollectionView];
    [_imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:_navBar];
    [_navBar setTitle:[NSString stringWithFormat:@"%@/%@",@(_currentIndex + 1).stringValue, @(_albumImageAssetArray.count).stringValue] textColor:nil];
    
    //添加手势
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:viewTap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _imageCollectionView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //滚动到当前图片位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [_imageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _imageCollectionView.hidden = NO;
    });
}

#pragma mark--点击
- (void)viewTapAction:(UIGestureRecognizer*)tap
{
    CGPoint tapLocation = [tap locationInView:self.view];
    
    if (!_navBar.hidden && CGRectContainsPoint(_navBar.frame, tapLocation))
    {
        return;
    }
    if (_navBar.isHidden)
    {
        _navBar.hidden = NO;
    }
    else
    {
        _navBar.hidden = YES;
    }
}

#pragma mark--UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动后改变顶部显示的当前位置
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _currentIndex = scrollView.contentOffset.x / screenWidth + 0.5;
    [_navBar setTitle:[NSString stringWithFormat:@"%ld/%lu",_currentIndex + 1, (unsigned long)_albumImageAssetArray.count] textColor:nil];
}

#pragma mark--UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _albumImageAssetArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCImageViewerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IMAGECELL forIndexPath:indexPath];
    cell.scrollView.zoomScale = 1.0;
    
    PHImageManager * manager = [PHImageManager defaultManager];
    
    if (cell.tag != 0)
    {
        [manager cancelImageRequest:(int)cell.tag];
    }
    DDCImageModel *model = _albumImageAssetArray[indexPath.item];
    if (model.image) {
        cell.image = model.image;
    } else{
        cell.tag = [manager requestImageForAsset:model.asset targetSize:self.view.bounds.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result)
            {
                cell.image = result;
            }
        }];
    }
    
    return cell;
}

-(void)didTapLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didTapRightBarButton
{
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
