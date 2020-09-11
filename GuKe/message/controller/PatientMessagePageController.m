//
//  PatientMessageController.m
//  GuKe
//
//  Created by 莹宝 on 2020/7/26.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMessagePageController.h"
#import "PatientBookController.h"
#import "PatientMessageController.h"

@interface PatientMessagePageController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) UIScrollView *bgScroll;
@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation PatientMessagePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.curIndex = 0;
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"留言信息", @"预约就诊", nil];
    for (int a = 0; a < titleArray.count; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(20 + ((ScreenWidth - 120)/2 + 60)* a, 0, (ScreenWidth - 120)/2, 39)];
        [btns setTitle:titleArray[a] forState:normal];
        [btns setTitleColor:titColor forState:normal];
        [btns setTitleColor:greenC forState:UIControlStateSelected];
        [btns addTarget:self action:@selector(clickedTopButton:) forControlEvents:UIControlEventTouchUpInside];
        btns.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:btns];
        btns.tag =  100 + a;
    }
    self.indicator = [[UIView alloc]initWithFrame:[self configureIndicatorFrameAtIndex:self.curIndex]];
    self.indicator.backgroundColor = greenC;
    [self.view addSubview:self.indicator];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 5)];
    line.backgroundColor = Color_rgba(240, 240, 240, 1);
    [self.view addSubview:line];
    
    self.bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight - 64 - 45)];
    self.bgScroll.delegate = self;
    self.bgScroll.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - 64 - 45);
    self.bgScroll.pagingEnabled = YES;
    [self.view addSubview:self.bgScroll];
    
    

    PatientMessageController *pmc = [[PatientMessageController alloc] init];
    pmc.view.frame = CGRectMake(0, 0, ScreenWidth, self.bgScroll.frame.size.height);
    [self.bgScroll addSubview:pmc.view];
    [self addChildViewController:pmc];
    [pmc didMoveToParentViewController:self];
    
    PatientBookController *pbc = [[PatientBookController alloc] init];
    pbc.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.bgScroll.frame.size.height);
    [self.bgScroll addSubview:pbc.view];
    [self addChildViewController:pbc];
    [pbc didMoveToParentViewController:self];
}

- (CGRect)configureIndicatorFrameAtIndex:(NSInteger)index
{
    ((UIButton *)[self.view viewWithTag:self.curIndex+100]).selected = NO;
    self.curIndex = index;
    ((UIButton *)[self.view viewWithTag:index+100]).selected = YES;
    return CGRectMake(20 + ((ScreenWidth - 120)/2 + 60)* index , 39, (ScreenWidth - 120)/2, 1);
}

- (void)clickedTopButton:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScroll.contentOffset = CGPointMake(ScreenWidth * (button.tag - 100), 0);
        self.indicator.frame = [self configureIndicatorFrameAtIndex:button.tag - 100];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.frame = [self configureIndicatorFrameAtIndex:index];
    }];
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
