//
//  WoDeShouCangViewController.m
//  GuKe
//
//  Created by yu on 2017/8/18.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "WoDeShouCangViewController.h"
#import "WoDeShouCangTableViewCell.h"

#import "ZiXunDetailViewController.h"
#import "ZJNSignUpMeetingViewController.h"
@interface WoDeShouCangViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *shoucangTable;
    NSMutableArray *collecArr;
    NSInteger page;
}

@end

@implementation WoDeShouCangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    page = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRefreshCollectList) name:@"collectList" object:nil];
    

    collecArr = [NSMutableArray array];
    [self makeaddTableview];
    [self makeData];
    // Do any additional setup after loading the view from its nib.
}

//返回按钮点击实现方法
-(void)backButtonClick{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
#pragma mark 刷新收藏列表
- (void)didRefreshCollectList{
    [collecArr removeAllObjects];

    [self makeData];
}
#pragma mark 我的收藏
- (void)makeData{
    page ++ ;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,collectionlistinfo];
    NSArray *keysArray = @[@"sessionid",@"page"];
    NSArray *valueArray = @[sessionIding,[NSString stringWithFormat:@"%ld",(long)page]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的收藏%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *collArr = [NSArray arrayWithArray:data[@"data"]];
            if (page == 1) {
                [collecArr removeAllObjects];
            }
            
            if (collArr.count > 0) {
                [collecArr addObjectsFromArray:data[@"data"]];
                
            }else{
                if (collecArr.count == 0) {
                    [self showHint:@"暂无数据"];
                }else{
                    [self showHint:@"暂无更多数据"];
                }
            }
            
        }else{
            page --;
            [self showHint:data[@"message"]];
        }
        [shoucangTable.mj_header endRefreshing];
        [shoucangTable.mj_footer endRefreshing];
        [self hideHud];
        [shoucangTable reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的收藏%@",error);
    }];

}
#pragma mark add view
- (void)makeaddTableview{
    shoucangTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, self.view.height - 45)];
    shoucangTable.delegate = self;
    shoucangTable.dataSource = self;
    shoucangTable.backgroundColor = SetColor(0xf0f0f0);
    shoucangTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:shoucangTable];
    shoucangTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self makeData];
    }];
    
    shoucangTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self makeData];
    }];
    
    

}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return collecArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    WoDeShouCangTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WoDeShouCangTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,collecArr[indexPath.section][@"image"]]] placeholderImage:[UIImage imageNamed:@"我组织的会议-img2"]];
    
    cellTwo.img.clipsToBounds = YES;
    cellTwo.contentMode = UIViewContentModeScaleAspectFill;
    
    cellTwo.titlaLab.text = [NSString stringWithFormat:@"%@",collecArr[indexPath.section][@"title"]];
  
    cellTwo.timeLab.text = [NSString stringWithFormat:@"%@",collecArr[indexPath.section][@"createTime"]];
    return cellTwo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZiXunDetailViewController *zi = [[ZiXunDetailViewController alloc]init];
    zi.collectID = [NSString stringWithFormat:@"%@",collecArr[indexPath.section][@"collectionId"]];
    zi.typeStr = [NSString stringWithFormat:@"1"];
    zi.title = @"收藏详情";
    zi.zixunID = [NSString stringWithFormat:@"%@",collecArr[indexPath.section][@"uid"]];
    zi.refershCollectStatusBlock = ^(NSString *shou) {
        page = 0;
        [self makeData];
    };
    [self.navigationController pushViewController:zi animated:NO];
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
