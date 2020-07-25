//
//  MineCollectViewController.m
//  GuKe
//
//  Created by MYMAc on 2018/3/23.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "MineCollectViewController.h"
#import "mineCollectView.h"

#import "WoDeShouCangViewController.h"
#import "WodeShoucangVideoViewController.h"

@interface MineCollectViewController ()<TopViewSelectDelegate,UIScrollViewDelegate>{
    mineCollectView * topView;
    UIScrollView * backScrollview;
}

@end

@implementation MineCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
 
    
    [self makeTopUI];
    [self makeBackScroView];
     // Do any additional setup after loading the view from its nib.
}
-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)makeTopUI{
      topView =[[mineCollectView alloc]init];
        [self.view addSubview:topView];
    topView.delegate = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
}
-(void)makeBackScroView{
    backScrollview =[[UIScrollView alloc]init];
    [self.view addSubview:backScrollview];
    backScrollview.contentSize = CGSizeMake(ScreenWidth * 2, self.view.height - topView.height);
    backScrollview.showsVerticalScrollIndicator = NO;
    backScrollview.showsHorizontalScrollIndicator = NO;
    backScrollview.delegate = self;
    backScrollview.pagingEnabled = YES;
    backScrollview.backgroundColor = [UIColor colorWithHex:0x999999];
    [backScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.view.height - topView.height);
        make.top.mas_equalTo(topView.mas_bottom);
    }];
    backScrollview.bounces= NO;
   
    
    WoDeShouCangViewController * oneView =[[WoDeShouCangViewController alloc]init];
    [self addChildViewController:oneView];
    
    WodeShoucangVideoViewController *twoView =[[WodeShoucangVideoViewController alloc]init];
    [self addChildViewController:twoView];
    [backScrollview addSubview:oneView.view];
    [backScrollview addSubview:twoView.view];

    [oneView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(backScrollview);
        make.width.mas_equalTo(backScrollview.mas_width);
        make.height.mas_equalTo(backScrollview.mas_height);
    }];
    [twoView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backScrollview);
        make.left.mas_equalTo(oneView.view.mas_right);
        make.width.mas_equalTo(backScrollview.mas_width);
        make.height.mas_equalTo(backScrollview.mas_height);

    }];

  
}
-(void)selectItemWithIndex:(NSInteger)index{
        backScrollview.mj_offsetX = self.view.width * index;
 }
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.mj_offsetX/scrollView.width;
   
    NSLog(@"offect = %ld",(long)index);

    [topView makeSelectItemWihtIndex:index];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
