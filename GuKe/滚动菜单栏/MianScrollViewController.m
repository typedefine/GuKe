//
//  MianScrollViewController.m
//  滚动菜单栏
//
//  Created by MYMAc on 2018/7/31.
//  Copyright © 2018年 kuaijiankang. All rights reserved.
//

#import "MianScrollViewController.h"
#import "CQScrollMenuView.h"
#import "UIView+frameAdjust.h"
@interface MianScrollViewController ()
<CQScrollMenuViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CQScrollMenuView * menuView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSArray * DataArray;

@end

@implementation MianScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"可水平 可竖直滑动";
//    self.view.backgroundColor = [];
    [self makemenuScrollow];
    // Do any additional setup after loading the view.
}
-(void)makemenuScrollow{
    
  self.DataArray = @[@"button0",@"button加长加长版",@"button2",@"button3",@"button4",@"button5",@"button6",@"button7",@"button8",@"button9",@"button10",@"button11"];
    
    // 创建滚动菜单栏
    self.menuView = [[CQScrollMenuView alloc]initWithFrame:CGRectMake(0,NavBarHeight, self.view.width, 40)];
    [self.view addSubview:self.menuView];
    self.menuView.menuButtonClickedDelegate = self;
    self.menuView.titleArray = self.DataArray;
    self.menuView.backgroundColor = [UIColor whiteColor];

//    水平
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
        
        UILabel * showlabl  =[[UILabel alloc]initWithFrame:CGRectMake(self.scrollView.width * i, 0, self.scrollView.width, 600)];
        showlabl.textAlignment = NSTextAlignmentCenter;
        showlabl.text = self.menuView.titleArray[i];
        [self.scrollView addSubview:showlabl];
    }
    [self.view addSubview:self.scrollView];
    
}
-(void)makeTableview{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuView.frame) +1, self.view.width, self.view.height - CGRectGetMaxY(self.menuView.frame)) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    
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







#pragma mark - UITableView DataSource & Delegate

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCellID = @"ReuseCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellID];
    }
    return cell;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

// 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuView.titleArray.count;
}

// 组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *reuseHeaderID = @"ReuseHeaderID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderID];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:reuseHeaderID];
    }
    
    return headerView;
}

// 组头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

// 组头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"第%ld组",section];
}

// 组头将要展示时回调
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    self.menuView.currentButtonIndex = section;
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
