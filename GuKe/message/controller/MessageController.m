//
//  MessageController.m
//  GuKe
//
//  Created by 莹宝 on 2020/7/26.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "MessageController.h"
#import "PatientMessagePageController.h"

@interface MessageController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentCtrl;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) NSArray *pageList;
@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation MessageController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.segmentCtrl.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.segmentCtrl.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.curIndex = 0;
    
    [self.navigationController.navigationBar addSubview:self.segmentCtrl];
    [self.segmentCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.navigationController.navigationBar);
    }];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.pageController didMoveToParentViewController:self];
    
    [self changeToViewControllerWithPageIndex:0];
    
}

- (NSArray *)pageList
{
    if (!_pageList) {
        _pageList = @[self.chatListVC, [[PatientMessagePageController alloc] init]];
    }
    return _pageList;
}


- (UIPageViewController *)pageController
{
    if (!_pageController) {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
        _pageController.dataSource = self;
        _pageController.delegate = self;
    }
    return  _pageController;
}


- (UISegmentedControl *)segmentCtrl
{
    if (!_segmentCtrl) {
        _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"医友消息",@"患者留言"]];
        [_segmentCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName:SetColor(0x06a27b)} forState:UIControlStateSelected];
        [_segmentCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} forState:UIControlStateNormal];
        [_segmentCtrl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:(UIControlEventValueChanged)];
        _segmentCtrl.selectedSegmentIndex = 0;
        _segmentCtrl.selected = YES;
    }
    return  _segmentCtrl;
}
    // Fallback on earlier versions


- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sCtrl
{
    [self changeToViewControllerWithPageIndex:sCtrl.selectedSegmentIndex];
}


- (void)changeToViewControllerWithPageIndex:(NSUInteger)index
{
    [self.pageController setViewControllers:@[self.pageList[index]] direction:self.curIndex>=index animated:YES completion:nil];//UIPageViewControllerNavigationDirectionForward
   self.curIndex = index;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    if (self.curIndex - 1 >= 0) {
        self.curIndex -= 1;
        return self.pageList[self.curIndex];
    }
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    if (self.curIndex + 1 < self.pageList.count) {
        self.curIndex += 1;
        return self.pageList[self.curIndex];
    }
    return nil;
}





@end
