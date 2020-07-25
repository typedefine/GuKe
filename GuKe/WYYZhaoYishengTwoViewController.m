//
//  WYYZhaoYishengTwoViewController.m
//  GuKe
//
//  Created by yu on 2018/1/16.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYZhaoYishengTwoViewController.h"
#import "WYYSouSuoYishengTableViewCell.h"
#import "WYYSearchYishengModel.h"
#import "WYYYishengDetailViewController.h"//医生详情
#import "ZJNFindDoctorTableViewCell.h"
@interface WYYZhaoYishengTwoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *qunliaoTableview;
    NSArray *titleArr;
    UITextField *searchText;
    NSMutableArray *doctorArr;
    NSInteger listnumber;
}

@end

@implementation WYYZhaoYishengTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找医生";
    self.view.backgroundColor = [UIColor whiteColor];
    doctorArr = [NSMutableArray array];
    listnumber = 0;
    [self makeaddtableview];
    
    // Do any additional setup after loading the view.
}
#pragma mark add tableview
-(void)makeaddtableview{
    //搜索框
    UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 30)];
    viewBack.backgroundColor = SetColor(0xeae9e9);
    viewBack.layer.masksToBounds = YES;
    viewBack.layer.cornerRadius = 15;
    [self.view addSubview:viewBack];
    
    UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    images.image = [UIImage imageNamed:@"搜索-搜索"];
    [viewBack addSubview:images];
    
    searchText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(images.frame) + 5, 0, 200, 30)];
    searchText.delegate = self;
    searchText.textColor = SetColor(0xb3b3b3);
    searchText.placeholder = @"请输入医生信息";
    searchText.font = Font12;
    [viewBack addSubview:searchText];
    
    
    UIButton *labelsa = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70,10 , 70, 30)];
    labelsa.titleLabel.font = Font14;
    [labelsa setTitle:@"搜索" forState:normal];
    [labelsa setTitleColor:titColor forState:normal];
    [labelsa addTarget:self action:@selector(didSouSuoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelsa];
    //
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
    lineView.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:lineView];
    
    if (IS_IPGONE_X) {
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth, ScreenHeight - 51 - 86)];
    }else{
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenWidth, ScreenHeight - 51 - 64)];
    }
    
    [self.view addSubview:qunliaoTableview];
    qunliaoTableview.delegate = self;
    qunliaoTableview.dataSource = self;
    qunliaoTableview.tableFooterView = [[UIView alloc]init];
    qunliaoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        listnumber = 0;
        [self makeData];
    }];
    qunliaoTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self makeData];
    }];
}
- (void)didSouSuoButton{
    [searchText resignFirstResponder];
    [doctorArr removeAllObjects];
    listnumber = 0;
    [self makeData];
}
#pragma mark 医生搜索列表
- (void)makeData{
    listnumber ++ ;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,userpatienthuanxindoclist];
    NSArray *keysArray = @[@"sessionId",@"doctorName",@"deptId",@"page"];
    NSArray *valueArray = @[sessionIding,searchText.text,@"",[NSString stringWithFormat:@"%ld",listnumber]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            if (listnumber == 1) {
                [doctorArr removeAllObjects];
            }
            
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            for (NSDictionary *dic in array) {
                WYYSearchYishengModel *model = [WYYSearchYishengModel yy_modelWithJSON:dic];
                [doctorArr addObject:model];
            }
            
            [qunliaoTableview reloadData];
            
        }else{
            listnumber -= 1;
        }
        [qunliaoTableview.mj_header endRefreshing];
        [qunliaoTableview.mj_footer endRefreshing];
        NSLog(@"医生搜索列表%@",data);
        
    } failure:^(NSError *error) {
        [qunliaoTableview.mj_header endRefreshing];
        [qunliaoTableview.mj_footer endRefreshing];
        [self hideHud];
        NSLog(@"医生搜索列表%@",error);
    }];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return doctorArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ZJNFindDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNFindDoctorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = doctorArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYYSearchYishengModel *model = doctorArr[indexPath.row];
    WYYYishengDetailViewController *detail = [[WYYYishengDetailViewController alloc]init];
    detail.doctorId = model.doctorId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:NO];
}
#pragma mark textfield  delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
