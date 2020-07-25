//
//  WYYHuanZheXiangQingViewController.m
//  GuKe
//
//  Created by yu on 2018/1/30.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYHuanZheXiangQingViewController.h"
#import "WYYDetailOneTableViewCell.h"
#import "WYYDetailTwoTableViewCell.h"
#import "WYYDetailThreeTableViewCell.h"
#import "WYYDetailHuanModel.h"
#import "ShuHouSUFangViewController.h"
#import "ZJNPatientBasicInfoViewController.h"
@interface WYYHuanZheXiangQingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *detailTableview;
    NSDictionary *detailDic;
    NSMutableArray *detailArr;
    NSArray *arrays;
    
}

@end

@implementation WYYHuanZheXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者详情";
    self.view.backgroundColor = [UIColor whiteColor];
    detailArr = [NSMutableArray array];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"删除好友" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self addTableview];
    [self makeDetailData];
    // Do any additional setup after loading the view.
}
#pragma mark 患者聊天--患者详情
- (void)makeDetailData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinlookpatient];
    NSArray *keysArray = @[@"sessionId",@"userId"];
    NSArray *valueArray = @[sessionIding,self.userIDStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"单聊---患者详情%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            detailDic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            arrays = [NSArray arrayWithArray:[detailDic objectForKey:@"list"]];
            for (NSDictionary *dica in arrays) {
                WYYDetailHuanModel *model = [WYYDetailHuanModel yy_modelWithJSON:dica];
                [detailArr addObject:model];
            }
            [detailTableview reloadData];
            
        }else{
            [self showHint:data[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}
#pragma mark 删除好友
- (void)onClickedOKbtn{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,userpatienthuanxindeletefriend];
    NSArray *keysArray = @[@"sessionId",@"doctorhuanId"];
    NSArray *valueArray = @[sessionIding,self.userIDStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            // 删除好友
            EMError *error = [[EMClient sharedClient].contactManager deleteContact:self.userIDStr isDeleteConversation:YES];
            if (!error) {
                //                NSLog(@"删除成功");
            }
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [self showHint:data[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
    
}
#pragma mark add tableview
- (void)addTableview{
    detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:detailTableview];
    detailTableview.backgroundColor = [UIColor whiteColor];
    detailTableview.delegate =self;
    detailTableview.dataSource = self;
    detailTableview.tableFooterView = [[UIView alloc]init];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return detailArr.count + 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 104;
    }else if(indexPath.row == 1){
        return 10;
    }else if(indexPath.row == 2){
        return 36;
    }else{
        return 75;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(10, 90, ScreenWidth - 20, 44)];
    btns.layer.masksToBounds = YES;
    btns.layer.cornerRadius = 21;
    btns.backgroundColor = greenC;
    [btns setTitle:@"添加病例" forState:normal];
    [btns setTitleColor:[UIColor whiteColor] forState:normal];
    btns.titleLabel.font = [UIFont systemFontOfSize:14];
    [btns addTarget:self action:@selector(addBingLi) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btns];
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *cellIdone = @"cellIdo";
        WYYDetailOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
        if (!cellOne) {
            cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYDetailOneTableViewCell" owner:self options:nil] lastObject];
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cellOne.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[detailDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
        cellOne.oneLab.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"name"]];
        NSString *sexStr = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"gender"]];
        if ([sexStr isEqualToString:@"1"]) {
            cellOne.twoLab.text = [NSString stringWithFormat:@"男   %@   %@",[detailDic objectForKey:@"age"],[detailDic objectForKey:@"nation"]];
        }else{
            cellOne.twoLab.text = [NSString stringWithFormat:@"女   %@   %@",[detailDic objectForKey:@"age"],[detailDic objectForKey:@"nation"]];
        }
        cellOne.threeLab.text = [NSString stringWithFormat:@"家庭住址:%@",[detailDic objectForKey:@"homeadress"]];
        
        return cellOne;
    }else if (indexPath.row == 1){
        static NSString *cellTwo = @"cellTwo";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
        
    }else if (indexPath.row == 2){
        static NSString *cellIdoneee = @"cellIee";
        WYYDetailTwoTableViewCell *cellOnea = [tableView dequeueReusableCellWithIdentifier:cellIdoneee];
        if (!cellOnea) {
            cellOnea = [[[NSBundle mainBundle]loadNibNamed:@"WYYDetailTwoTableViewCell" owner:self options:nil] lastObject];
            cellOnea.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cellOnea;
    }else{
        static NSString *cellIdoneww = @"cellIdoer";
        WYYDetailThreeTableViewCell *cellOneas = [tableView dequeueReusableCellWithIdentifier:cellIdoneww];
        if (!cellOneas) {
            cellOneas = [[[NSBundle mainBundle]loadNibNamed:@"WYYDetailThreeTableViewCell" owner:self options:nil] lastObject];
            cellOneas.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellOneas.model = detailArr[indexPath.row - 3];
        return cellOneas;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYYDetailHuanModel *model = detailArr[indexPath.row - 3];
    
    NSString *strings = model.hospnumId;
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    [defau setObject:strings forKey:@"hospitalnumbar"];
    [defau synchronize];
    ShuHouSUFangViewController *shu = [[ShuHouSUFangViewController alloc]init];
    //shu.numbers = 0;
    shu.zhuyuanhao = model.hospNum;
    shu.infoDic = detailDic;
    shu.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:shu animated:NO];
}
#pragma mark 添加病例
- (void)addBingLi{
    ZJNPatientBasicInfoViewController *info = [[ZJNPatientBasicInfoViewController alloc]init];
    info.hidesBottomBarWhenPushed = YES;
    info.chatAddPatient = @"chatAdd";
    info.infoDic = detailDic;
    [self.navigationController pushViewController:info animated:NO];
    
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
