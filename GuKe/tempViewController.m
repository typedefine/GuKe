//
//  tempViewController.m
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import "tempViewController.h"
#import "CQScrollMenuView.h"
#import "UIView+frameAdjust.h"
#import "orderViewController.h"
@interface tempViewController ()<CQScrollMenuViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) CQScrollMenuView * menuView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSArray * DataArray;


@end

@implementation tempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self makemenuScrollow];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    // Do any additional setup after loading the view.
}
//返回按钮点击实现方法
-(void)backButtonClick{
   
    [self dismissViewControllerAnimated:NO completion:nil];
            
 
}
-(void)makemenuScrollow{
    
    self.DataArray = @[@"全部",@"待支付",@"已支付",@"已使用",@"未使用",@"逾期",@"赠送"];
    
    // 创建滚动菜单栏
    self.menuView = [[CQScrollMenuView alloc]initWithFrame:CGRectMake(0,0, self.view.width, 40)];
    [self.view addSubview:self.menuView];
    self.menuView.menuButtonClickedDelegate = self;
    self.menuView.lineColor = [UIColor colorWithHex:0xf5f5f5];
    self.menuView.selectBtnColor = [UIColor colorWithHex:0x06a27b];
    //    水平
    self.menuView.titleArray = self.DataArray;
    self.menuView.backgroundColor = [UIColor whiteColor];
  
    [self makeScrollview];
    //   竖直
    //    [self makeTableview];
    
}
-(void)makeScrollview{
    
    
    // Scrollview 滚动视图
    self.scrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.menuView.maxY +1, self.view.width, self.view.height - self.menuView.minY)];
    self.scrollView.delegate = self;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize  = CGSizeMake(self.scrollView.width * self.menuView.titleArray.count, self.scrollView.height);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    for (int i  = 0 ;  i < self.menuView.titleArray.count ; i++ ) {
        
       
        orderViewController * order =[[orderViewController alloc]init];
        order.statc = [NSString stringWithFormat:@"%d",i];
        [self addChildViewController:order];
         order.view.frame = CGRectMake(i *ScreenWidth, 0, ScreenWidth, ScreenHeight);
//        UILabel * showlabl  =[[UILabel alloc]initWithFrame:CGRectMake(self.scrollView.width * i, 0, self.scrollView.width, 600)];
//        showlabl.textAlignment = NSTextAlignmentCenter;
//        showlabl.text = self.menuView.titleArray[i];
        [self.scrollView addSubview:order.view];
    }
    [self.view addSubview:self.scrollView];
    
}

// menuView 的代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.menuView.currentButtonIndex   =  scrollView.contentOffset.x/scrollView.width;
    
    NSLog(@"scrollViewDidEndDecelerating  -   End of Scrolling.");
}
#pragma mark - Delegate - 菜单栏
// 菜单按钮点击时回调
- (void)scrollMenuView:(CQScrollMenuView *)scrollMenuView clickedButtonAtIndex:(NSInteger)index{
    if(self.menuView){
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width * index, 0);
    }else{
        
        // tableView滚动到对应组
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    
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
