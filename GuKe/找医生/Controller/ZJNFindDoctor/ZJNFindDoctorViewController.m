//
//  ZJNFindDoctorViewController.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNFindDoctorViewController.h"
#import "ZJNFindDoctorTableViewCell.h"
#import "ZJNMyDoctorListModel.h"
#import "ZJNProvincesView.h"
#import "ZJNHospitalsView.h"
#import "ZJNDepartmentView.h"
//#import "ZJHMyDoctorInfoViewController.h"
#import "ZJNSearchDoctorViewController.h"
#import "WYYYishengDetailViewController.h"
#import "WYYZhaoYishengTwoViewController.h"//找医生
@interface ZJNFindDoctorViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNProvincesViewDelegate,ZJNHospitalsViewDelegate,ZJNDepartmentViewDelegate>
{
    UIButton *recordButton;//记录当前顶部被选中的按钮
    NSInteger page;
    NSString *areaStr;//区
    NSString *hospStr;//医院
    NSString *deptStr;//科室
}
@property (nonatomic ,strong)UITableView      *tableView;
@property (nonatomic ,strong)ZJNProvincesView *provincesView;
@property (nonatomic ,strong)ZJNHospitalsView *hospitalsView;
@property (nonatomic ,strong)ZJNDepartmentView*departmentView;
@property (nonatomic ,strong)NSMutableArray   *dataArr;
@end

@implementation ZJNFindDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找医生";
    page = 1;
    deptStr = @"";
    hospStr =@"";
    _dataArr = [NSMutableArray array];
    //搜索
    UIBarButtonItem *rightMaxBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonClick)];
    //UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索icon"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClick)];
    self.navigationItem.rightBarButtonItem = rightMaxBt;
    [self creatThreeButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.provincesView];
    [self.view addSubview:self.hospitalsView];
    [self.view addSubview:self.departmentView];
    
    [self getDataFromServiceWithDeptId:deptStr];
    
    // Do any additional setup after loading the view.
}

-(void)creatThreeButton{
    NSArray *titleArr = @[@"地区",@"医院",@"科室"];
    for (int i =0; i <3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i *(ScreenWidth/3.0), 0, ScreenWidth/3.0, 40);
        button.titleLabel.font = SetFont(14);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:SetColor(0x1a1a1a) forState:UIControlStateNormal];
        [button setTitleColor:SetColor(0x06a27b) forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"三角-选择"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"三角_当前"] forState:UIControlStateSelected];
        CGFloat imageViewWidth = CGRectGetWidth(button.imageView.frame);
        
        CGFloat labelWidth = CGRectGetWidth(button.titleLabel.frame);
        
        button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+5, 0, -labelWidth-5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageViewWidth-5, 0, imageViewWidth+5);
        [button addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        [self.view addSubview:button];
    }
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight-40) style:UITableViewStylePlain];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            [self getDataFromServiceWithDeptId:deptStr];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page += 1;
            [self getDataFromServiceWithDeptId:deptStr];
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(ZJNProvincesView *)provincesView{
    if (!_provincesView) {
        _provincesView = [[ZJNProvincesView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight-40)];
        _provincesView.delegate = self;
        _provincesView.hidden = YES;
    }
    return _provincesView;
}
-(ZJNHospitalsView *)hospitalsView{
    if (!_hospitalsView) {
        _hospitalsView = [[ZJNHospitalsView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight-40)];
        _hospitalsView.delegate = self;
        _hospitalsView.hidden = YES;
    }
    return _hospitalsView;
}
-(ZJNDepartmentView *)departmentView{
    if (!_departmentView) {
        _departmentView = [[ZJNDepartmentView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight-40)];
        _departmentView.delegate = self;
        _departmentView.hidden = YES;
    }
    return _departmentView;
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
}
//顶部按钮点击实现方法
-(void)threeButtonClick:(UIButton *)button
{
    
    if (button.selected) {
        recordButton.selected = NO;
    }else{
        if (button.tag == 11) {
            if (areaStr==nil) {
                [self showHint:@"请先选择省市区"];
                return;
            }
        }else if (button.tag == 12){
            if (hospStr==nil) {
                [self showHint:@"请先选择医院"];
                return;
            }
        }
        recordButton.selected = NO;
        button.selected = YES;
        recordButton = button;
    }
    
    if (button.tag == 10) {
        _hospitalsView.hidden = YES;
        _departmentView.hidden = YES;
        _provincesView.hidden = !recordButton.selected;
    }else if (button.tag == 11){
        _provincesView.hidden = YES;
        _departmentView.hidden = YES;
        _hospitalsView.hidden = !recordButton.selected;
    }else{
        _provincesView.hidden = YES;
        _hospitalsView.hidden = YES;
        _departmentView.hidden = !recordButton.selected;
    }
}
//
-(void)searchButtonClick{
    WYYZhaoYishengTwoViewController *viewC = [[WYYZhaoYishengTwoViewController alloc] init];
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:YES];
}
#pragma mark -ZJNProvincesViewDelegate

- (void)provincesViewCanceled
{
    UIButton *button = (UIButton *)[self.view viewWithTag:10];
    button.selected = NO;
//    if (recordButton == button) {
//        recordButton.selected = NO;
//    }
}

-(void)provincesViewSearchDoctorWithArea:(NSString *)area hospitalArr:(NSArray *)hospArr{
    areaStr = area;
    
    NSLog(@"%@",area);
    [self.hospitalsView reloadDataWithHospitalArray:hospArr];
    UIButton *button = (UIButton *)[self.view viewWithTag:10];
    [self threeButtonClick:button];
    UIButton *buttsons = (UIButton *)[self.view viewWithTag:11];
    [self threeButtonClick:buttsons];
}


#pragma mark--ZJNHospitalsViewDelegate

- (void)zjnHospitalsViewCanceled
{
    UIButton *buttson = (UIButton *)[self.view viewWithTag:11];
    buttson.selected = NO;
}

-(void)zjnHospitalsViewSelectedHospitalWithHospitalName:(NSString *)hospitalName departmentArr:(NSArray *)deptArr{
    [self.departmentView reloadDataWithDeptArray:deptArr];

    UIButton *button = (UIButton *)[self.view viewWithTag:11];
    [self threeButtonClick:button];
    hospStr = hospitalName;
    NSLog(@"%@",hospitalName);
   
    page = 1;
    [self getDataFromServiceWithDeptId:@""];

}
#pragma mark--ZJNDepartmentViewDelegate

- (void)zjnDeptViewCanceled
{
    UIButton *buttson = (UIButton *)[self.view viewWithTag:12];
    buttson.selected = NO;
}

-(void)zjnDeptViewSelectedDepartmentWithID:(NSString *)deptID{
    UIButton *button = (UIButton *)[self.view viewWithTag:12];
    [self threeButtonClick:button];
    NSLog(@"%@",deptID);
    deptStr = deptID;
    page = 1;
    [self getDataFromServiceWithDeptId:deptID];
}
-(void)getDataFromServiceWithDeptId:(NSString *)deptId{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)page];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,userpatienthuanxindoclist];
    NSArray *keysArr = @[@"sessionId",@"doctorName",@"deptId",@"page"];
    NSArray *valuesArr = @[sessionIding,hospStr,deptId,pageStr];
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
            [self.tableView reloadData];
        }else{
            page-=1;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:@"请求服务器失败"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
    }];
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
