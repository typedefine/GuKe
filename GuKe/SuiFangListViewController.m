//
//  SuiFangListViewController.m
//  GuKe
//
//  Created by yu on 2017/8/25.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SuiFangListViewController.h"
#import "SuiFangJiLuTableViewCell.h"
#import "ShuHouSUFangViewController.h"
@interface SuiFangListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *suiListTable;
    NSMutableArray *suiArr;
    int numberss;
}

@end

@implementation SuiFangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已随访记录";
    numberss -- ;
    suiArr = [NSMutableArray array];
    [self makeADDtable];
    [self makeSuiFanglist];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 我已随访
- (void)makeSuiFanglist{
    numberss ++;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientchecklist];
    NSArray *keysArray = @[@"sessionid",@"page"];
    NSArray *valueArray = @[sessionIding,[NSString stringWithFormat:@"%d",numberss]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我已随访%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            if (arrays.count > 0) {
                if (numberss == 1) {
                    [suiArr removeAllObjects];
                    [suiArr addObjectsFromArray:data[@"data"]];
                }else{
                    
                    [suiArr addObjectsFromArray:data[@"data"]];
                }
                
            }else{
                if (suiArr.count == 0) {
                    [self showHint:@"暂无数据"];
                }else{
                    [self showHint:@"暂无更多数据"];
                }
                numberss -- ;
            }
            
        }else{
            numberss --;
            [self showHint:@"暂无数据"];
        }

        [suiListTable reloadData];
        [suiListTable.mj_header endRefreshing];
        [suiListTable.mj_footer endRefreshing];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        numberss -- ;
        [suiListTable.mj_header endRefreshing];
        [suiListTable.mj_footer endRefreshing];
        NSLog(@"我已随访%@",error);
    }];

}
#pragma mark add tableview
- (void)makeADDtable{
    suiListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    suiListTable.delegate = self;
    suiListTable.dataSource = self;
    suiListTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:suiListTable];
    
    suiListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        numberss = 0;
        [self makeSuiFanglist];
    }];
    
    suiListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self makeSuiFanglist];
    }];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return suiArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    SuiFangJiLuTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"SuiFangJiLuTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    NSDictionary *disa = suiArr[indexPath.row];
    
    /*
    NSString *gender = [NSString stringWithFormat:@"%@",[disa objectForKey:@"gender"]];
    if ([gender isEqualToString:@"1"]) {
        cellTwo.nameLab.text = [NSString stringWithFormat:@"%@    男    %@岁",[disa objectForKey:@"patientName"],[disa objectForKey:@"age"]];
        [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[disa objectForKey:@"patientImage"]]] placeholderImage:[UIImage imageNamed:@"nan"]];
    }else if ([gender isEqualToString:@"0"]){
        cellTwo.nameLab.text = [NSString stringWithFormat:@"%@    女    %@岁",[disa objectForKey:@"patientName"],[disa objectForKey:@"age"]];
        [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[disa objectForKey:@"patientImage"]]] placeholderImage:[UIImage imageNamed:@"nv"]];
    }
    cellTwo.phoneLab.text = [NSString stringWithFormat:@"%@",[disa objectForKey:@"phone"]];
    cellTwo.zhuankeLab.text = [NSString stringWithFormat:@"专科检查：%@",[disa objectForKey:@"checks"]];
    cellTwo.timelab.text = [NSString stringWithFormat:@"检查时间：%@",[disa objectForKey:@"callbackTime"]];
    */
    
    return cellTwo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strings = suiArr[indexPath.row][@"hospnumId"];
    
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    [defau setObject:strings forKey:@"hospitalnumbar"];
    [defau synchronize];
    
    ShuHouSUFangViewController *shu = [[ShuHouSUFangViewController alloc]init];
    shu.numbers = 2;
    shu.infoDic = suiArr[indexPath.row];
    shu.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:shu animated:NO];
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
