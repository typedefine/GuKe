//
//  WoDeViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "WoDeViewController.h"
#import "TongYongSettingViewController.h"
#import "PersonViewController.h"
#import "ChangeGeRenInfoViewController.h"
//#import "WoDeShouCangViewController.h"
#import "MineCollectViewController.h"
#import "GuKeNavigationViewController.h"
#import "ZJNShareView.h"
#import "ZJNShareDialogsView.h"
#import "tempViewController.h"
#pragma mark--医生信息Model类
#import "UserInfoModel.h"
#import "QJCKFViewcontroller.h"
#pragma mark--自定义单元格
//展示个人信息
#import "PersonalCenterTableViewCell.h"

#import "PersonInfoTableViewCell.h"

#import "ZJNDoctorInfoViewController.h"
#import "WYYNewFriendViewController.h"//新的朋友
#import "WYYzuZhiHuiYiViewController.h"//我组织的会议
#import "MemberApplyController.h"

@interface WoDeViewController ()<UITableViewDelegate,UITableViewDataSource,PersonalCenterDelegate>{
    UITableView *mainTableview;
    NSDictionary *infoDic;//存放请求到的个人信息
    NSArray *imgArr;
    NSArray *titArr;
    NSString *renzhengType;//认证状态
    CGRect zhiweiRect;//职位宽度
    CGRect nameRect;//名字宽度
    UIButton *btn;//右上角信封Button
    BOOL isRenZheng;
    
}
@end

@implementation WoDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgArr = @[@[@"订单中心",@"center_icon1"],@[@"center_icon2",@"center_icon3"],@[@"新的朋友",@"group_create",@"我组织的会议",@"center_icon5",@"center_icon6",@"在线客服",@"center_icon4"]];
    
    titArr =@[@[@"订单中心",@"个人资料"],@[@"同道",@"我的团队"],@[@"新的朋友",@"群成员申请",@"我组织的会议",@"推荐",@"我的收藏",@"在线客服",@"设置"]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLetterState) name:@"changeLetterState" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableview) name:@"newFriendRefresh" object:nil];
    
    [self makeAddTableview];
    [self makeDataZhanshi];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 刷新tableview
- (void)refreshTableview{
    [mainTableview reloadData];
}
//收到新消息改变信封按钮图片
-(void)changeLetterState{
    PersonalCenterTableViewCell *cell = (PersonalCenterTableViewCell *)[mainTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.letterButton setImage:[UIImage imageNamed:@"红点信封"] forState:UIControlStateNormal];
    
}
#pragma mark 个人资料展示
- (void)makeDataZhanshi{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorshow];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"个人资料展示%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            infoDic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            SetChatImgUrl(infoDic[@"portrait"]);
            SetChatUserName(infoDic[@"doctorName"]);
            Synchronize;
            
        }else{
            
        }
        [mainTableview reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"个人资料展示%@",error);
    }];
}

#pragma mark addtableview
- (void)makeAddTableview{
    
    mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    mainTableview.delegate = self;
    mainTableview.dataSource = self;
    mainTableview.scrollEnabled = NO;
    mainTableview.backgroundColor = SetColor(0xf0f0f0);
    mainTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:mainTableview];
}


#pragma mark tableview delegate
#pragma mark--分割线去掉左边十五个像素
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        
        return 0;
    }else if (section == 3){
        return 7;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 0.01;
    }else{
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (ScreenHeight>736) {
            if ([ZJNDeviceInfo deviceIsPhone]) {
                return 180;
            }
            return 150;
        }else{
            return 150;
        }
    }else{
//        if (indexPath.section==3 && indexPath.row == 1) {
//            return CGFLOAT_MIN;
//        }
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellid = @"cellid";
        PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterTableViewCell" owner:self options:nil]lastObject];
        }
        
        UITabBarItem *meItem = [self.tabBarController.tabBar.items objectAtIndex:3];
        if ([meItem.badgeValue integerValue]>0) {
            [cell.letterButton setImage:[UIImage imageNamed:@"红点信封"] forState:UIControlStateNormal];
        }
        cell.letterButton.hidden = YES;
        cell.backButton.hidden = YES;
        cell.delegate = self;
        cell.model = [UserInfoModel yy_modelWithDictionary:infoDic];
        return cell;
    }else{
        static NSString *cellid = @"cellId";
        PersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonInfoTableViewCell" owner:self options:nil]lastObject];
        }
        
        if ((indexPath.section == 3)&&(indexPath.row == 0)) {
            NSString *viewH = [NSString stringWithFormat:@"%@",newDriend];
            if ([viewH isEqualToString:@"10"]) {
                cell.redView.hidden = NO;
            }else{
                cell.redView.hidden = YES;
            }
            
        }else{
            cell.redView.hidden = YES;
        }
        cell.headerImageV.image = [UIImage imageNamed:imgArr[indexPath.section-1][indexPath.row]];
        cell.nameLabel.text = titArr[indexPath.section-1][indexPath.row];
//        if (indexPath.section == 3 && indexPath.row == 1) {
//            cell.contentView.hidden = YES;
//        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
       
        if(indexPath.row == 0){
            
            tempViewController  * pv =[[tempViewController
                                        alloc]init];
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:pv];

            [self presentViewController:nav animated:NO completion:nil];

        }else{
            PersonViewController *pe = [[PersonViewController alloc]init];
            //提交个人资料后需要刷新
            pe.submitInfoSucess = ^{
                [self makeDataZhanshi];
            };
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:pe];
            [self presentViewController:nav animated:NO completion:nil];
        }
        
       
    }else if (indexPath.section == 2){
        
    }else{
        if (indexPath.row == 0) {
            //新的朋友
            WYYNewFriendViewController *pe = [[WYYNewFriendViewController alloc]init];
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:pe];
            [self presentViewController:nav animated:NO completion:nil];
            
        }else if(indexPath.row == 1){
//            ApplyViewController *vc = [ApplyViewController shareController];
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:[[MemberApplyController alloc] init]];
            [self presentViewController:nav animated:NO completion:nil];
        }else if(indexPath.row == 2){
            //我组织的会议
            //我组织的会议
            WYYzuZhiHuiYiViewController *pe = [[WYYzuZhiHuiYiViewController alloc]init];
            
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:pe];
            [self presentViewController:nav animated:NO completion:nil];
        }else if (indexPath.row == 3) {
            ZJNShareDialogsView *shareView = [[ZJNShareDialogsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            [shareView show];
        }else if (indexPath.row == 4){
            MineCollectViewController *shou = [[MineCollectViewController alloc]init];
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:shou];
            [self presentViewController:nav animated:NO completion:nil];
        }else if (indexPath.row == 5){
            
            QJCKFViewcontroller *tong = [[QJCKFViewcontroller alloc]init];
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:tong];
            [self presentViewController:nav animated:NO completion:nil];
            
        }else{
            TongYongSettingViewController *tong = [[TongYongSettingViewController alloc]init];
            GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:tong];
            [self presentViewController:nav animated:NO completion:nil];
        }
    }
}
#pragma mark--PersonalCenterDelegate
-(void)personalCenterShowDoctorDetailInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ZJNDoctorInfoViewController *viewC = [[ZJNDoctorInfoViewController alloc]init];
        viewC.infoDic = infoDic;
        [self presentViewController:viewC animated:NO completion:^{
            
        }];
    });
    
}
-(void)personalCenterShowDoctorChatHistory{
    
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
