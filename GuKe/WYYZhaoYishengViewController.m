//
//  WYYZhaoYishengViewController.m
//  GuKe
//
//  Created by yu on 2018/1/16.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYZhaoYishengViewController.h"
#import "WYYZhaoYishengTwoViewController.h"//关键字搜索医生页面
#import "WYYSouSuoYishengTableViewCell.h"
#import "WYYYishengDetailViewController.h"//医生详情
#import "WYYSearchYishengModel.h"
@interface WYYZhaoYishengViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *qunliaoTableview;
    NSArray *titleArr;
    NSMutableArray *docArr;
}


@end

@implementation WYYZhaoYishengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找医生";
    self.view.backgroundColor = [UIColor whiteColor];
    docArr = [NSMutableArray array];
    //搜索
    UIBarButtonItem *rightMaxBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(maxBtA)];
    self.navigationItem.rightBarButtonItem = rightMaxBt;
    
    [self makeaddtableview];
    //[self makeData];
    // Do any additional setup after loading the view.
}
#pragma mark 省市区医院科室五级联动
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,userpatienthuanxinlist];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
        if (arrays.count == 0) {
            
        }else{
            for (NSDictionary *dic in arrays) {
                WYYSearchYishengModel *model = [WYYSearchYishengModel yy_modelWithJSON:dic];
                [docArr addObject:model];
            }
            [qunliaoTableview reloadData];
            
        }
        NSLog(@"省市区医院科室五级联动%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"省市区医院科室五级联动%@",error);
    }];
}
- (void)maxBtA{
    WYYZhaoYishengTwoViewController *two = [[WYYZhaoYishengTwoViewController alloc]init];
    two.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:two animated:NO];
}
#pragma mark add tableview
-(void)makeaddtableview{
    if (IS_IPGONE_X) {
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, ScreenWidth, ScreenHeight - 54 - 86)];
    }else{
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, ScreenWidth, ScreenHeight - 54 - 64)];
    }
    
    [self.view addSubview:qunliaoTableview];
    qunliaoTableview.delegate = self;
    qunliaoTableview.dataSource = self;
    qunliaoTableview.tableFooterView = [[UIView alloc]init];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return docArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdone = @"cellIdone";
    WYYSouSuoYishengTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
    if (!cellOne) {
        cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYSouSuoYishengTableViewCell" owner:self options:nil] lastObject];
        cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WYYSearchYishengModel *model = docArr[indexPath.row];
    cellOne.model = model;
    
    cellOne.zhiweiLab.text = [NSString stringWithFormat:@"%@",model.titleName];
    CGRect whiteRect = [cellOne.zhiweiLab boundingRectWithInitSize:cellOne.zhiweiLab.frame.size];
    cellOne.zhiweiLab.frame = CGRectMake(ScreenWidth - 15 - 100, 10, whiteRect.size.width, 15);
    
    return cellOne;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYYSearchYishengModel *model = docArr[indexPath.row];
    WYYYishengDetailViewController *detail = [[WYYYishengDetailViewController alloc]init];
    detail.doctorId = model.doctorId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:NO];
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
