//
//  ZJNMRShareDoctorViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/1.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNMRShareDoctorViewController.h"
#import "ZJNSelectDoctorTableViewCell.h"
@interface ZJNMRShareDoctorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *selectedArr;
@end

@implementation ZJNMRShareDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请医生";
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okButtonClick)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    if (self.dataArr.count == 0) {
        
    }else{
        [self.selectedArr addObjectsFromArray:self.dataArr];
    }
    
    [self.view addSubview:self.tableView];
    [self getDataFromService];
    // Do any additional setup after loading the view.
}
-(void)getDataFromService{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,hospdoctorlist];
    NSDictionary *dic = @{@"sessionId":sessionIding};
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retCode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retCode isEqualToString:@"0000"]) {
            self.dataArray = data[@"data"];
            [self.tableView reloadData];
        }else{
            [self showHint:data[@"message"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight) style:UITableViewStyleGrouped];
        _tableView.allowsMultipleSelection = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
#pragma mark--
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ZJNSelectDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNSelectDoctorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell.headImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,dic[@"portrait"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    cell.nameLabel.text = dic[@"doctorName"];
    for (NSDictionary *kDic in self.dataArr) {
        if ([kDic[@"uid"] isEqualToString:dic[@"uid"]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectedArr addObject:self.dataArray[indexPath.row]];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *deselectedDic = self.dataArray[indexPath.row];
    for (NSDictionary *dic in self.selectedArr) {
        if ([dic[@"uid"] isEqualToString:deselectedDic[@"uid"]]) {
            [self.selectedArr removeObject:dic];
            break;
        }
    }
}
//确定按钮点击实现方法
-(void)okButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareDoctorWithArray:)]) {
        [self.delegate shareDoctorWithArray:self.selectedArr];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [_tableView reloadData];
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
