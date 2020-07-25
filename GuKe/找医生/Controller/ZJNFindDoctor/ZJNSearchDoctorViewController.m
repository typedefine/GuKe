//
//  ZJNSearchDoctorViewController.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNSearchDoctorViewController.h"
#import "ZJNFindDoctorTableViewCell.h"
#import "ZJNMyDoctorListModel.h"
#import "WYYYishengDetailViewController.h"
@interface ZJNSearchDoctorViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *searchText;
    NSInteger page;
}
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic ,strong)UIView *topBgView;
@property (nonatomic ,strong)UITextField *searchTextfield;
@property (nonatomic ,strong)UIButton *searchButton;
@property (nonatomic ,strong)NSMutableArray *dataArr;
@end

@implementation ZJNSearchDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找医生";
    page = 0;
    _dataArr = [NSMutableArray array];
    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.tableview];
    // Do any additional setup after loading the view.
}
-(void)getdataFromService{
    page +=1;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,userpatienthuanxindoclist];
    NSArray *keysArr = @[@"sessionId",@"doctorName",@"deptId",@"page"];
    NSArray *valuesArr = @[sessionIding,searchText,@"",pageStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            if (page == 1) {
                [_dataArr removeAllObjects];
            }
            NSArray *array = data[@"data"];
            for (NSDictionary *dic in array) {
                ZJNMyDoctorListModel *model = [ZJNMyDoctorListModel yy_modelWithDictionary:dic];
                [_dataArr addObject:model];
            }
            [self.tableview reloadData];
        }else{
            page-=1;
        }
        [self hideHud];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:@"连接服务器失败"];
        [self hideHud];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}
-(UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        _topBgView.backgroundColor = [UIColor whiteColor];
        [_topBgView addSubview:self.searchTextfield];
        [_topBgView addSubview:self.searchButton];
    }
    return _topBgView;
}
-(UITextField *)searchTextfield{
    if (!_searchTextfield) {
        _searchTextfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-50, 28)];
        _searchTextfield.borderStyle = UITextBorderStyleRoundedRect;
        _searchTextfield.backgroundColor = SetColor(0xeae9e9);
        _searchTextfield.font = SetFont(12);
        _searchTextfield.placeholder = @"请输入医生姓名或医院名称";
    
        [_searchTextfield addTarget:self action:@selector(searchTextFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextfield;
}
-(UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(ScreenWidth-40, 0, 40, 48);
        [_searchButton setImage:[UIImage imageNamed:@"灰色搜索icon"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 48, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight-48) style:UITableViewStylePlain];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 0;
            [self getdataFromService];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self getdataFromService];
        }];
        _tableview.mj_footer.hidden = YES;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        
    }
    return _tableview;
}
//搜索按钮点击实现方法
-(void)searchButtonClicked{
    [_searchTextfield resignFirstResponder];
    page = 0;
    
    [self getdataFromService];
}
//搜索框绑定方法
-(void)searchTextFieldTextChanged:(UITextField *)textfield{
    searchText = textfield.text;
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ZJNFindDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNFindDoctorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = _dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYYYishengDetailViewController *viewC = [[WYYYishengDetailViewController alloc]init];
    ZJNMyDoctorListModel *model  = _dataArr[indexPath.row];
    viewC.doctorId = model.doctorId;
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:YES];
    
//    ZJHMyDoctorInfoViewController *viewC = [[ZJHMyDoctorInfoViewController alloc]init];
//    viewC.infoModel = _dataArr[indexPath.row];
//    viewC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:viewC animated:YES];
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
