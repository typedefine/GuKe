//
//  WYYNewFriendViewController.m
//  GuKe
//
//  Created by yu on 2018/1/18.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYNewFriendViewController.h"
#import "WYYNewFriendTableViewCell.h"
#import "WYYHuanZheDetaiViewController.h"//患者详情
#import "WYYAddYiShengDetailViewController.h"//医生详情
@interface WYYNewFriendViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *detailTableview;
    NSArray *titleaRR;
    NSMutableArray *listArr;
}


@end

@implementation WYYNewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的朋友";
    self.view.backgroundColor = [UIColor whiteColor];
    
    listArr = [NSMutableArray array];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self makeAddTableview];
    [self makeData];
    
    // Do any additional setup after loading the view.
}
//返回按钮点击实现方法
-(void)backButtonClick{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"newFriendRefresh" object:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
#pragma mark 好友申请列表
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfriendaddlist];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"好友申请列表%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            
            if (array.count > 0) {
                SetnewDriend(@"10");
            }else{
                SetnewDriend(@"5");
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
            for (NSDictionary *dic in array) {
                WYYAddFriendList *model = [WYYAddFriendList yy_modelWithJSON:dic];
                [listArr addObject:model];
            }
            [detailTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"好友申请列表%@",error);
    }];
}
- (void)makeAddTableview{
    if (IS_IPGONE_X) {
        detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 86)];
    }else{
        detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    }

    detailTableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:detailTableview];
    detailTableview.delegate = self;
    detailTableview.dataSource = self;
    detailTableview.tableFooterView = [[UIView alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdone = @"cellIdone";
    WYYNewFriendTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
    if (!cellOne) {
        cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYNewFriendTableViewCell" owner:self options:nil] lastObject];
        cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cellOne.okBtn addTarget:self action:@selector(didOkButton:) forControlEvents:UIControlEventTouchUpInside];
    cellOne.okBtn.tag = indexPath.row;
    
    WYYAddFriendList *model = listArr[indexPath.row];
    cellOne.model = model;
    return cellOne;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WYYAddFriendList *model = listArr[indexPath.row];
    if ([model.state isEqualToString:@"1"]) {
        WYYHuanZheDetaiViewController *huan = [[WYYHuanZheDetaiViewController alloc]init];
        huan.userID = model.userid;
        huan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:huan animated:NO];
    }else{
        WYYAddYiShengDetailViewController *huan = [[WYYAddYiShengDetailViewController alloc]init];
        huan.userID = model.userid;
        huan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:huan animated:NO];
    }
     
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拒绝" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除收藏
        WYYAddFriendList *model = listArr[indexPath.row];
        [self didCanCelButton:model.userid];

    }];
    action.backgroundColor = SetColor(0xFF3B30);
    
    return @[action];
    
}
#pragma mark 同意按钮
- (void)didOkButton:(UIButton *)sender{
    WYYAddFriendList *model = listArr[sender.tag];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfriendadd];
    NSArray *keysArray = @[@"sessionId",@"userid"];
    NSArray *valueArray = @[sessionIding,model.userid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"同意添加%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [listArr removeAllObjects];
            [self makeData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"同意添加%@",error);
    }];
}
#pragma mark 拒绝按钮
- (void)didCanCelButton:(NSString *)useridStr{
    
    
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfrienddelete];
    NSArray *keysArray = @[@"sessionId",@"userid"];
    NSArray *valueArray = @[sessionIding,useridStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"拒绝添加%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:useridStr];
            if (!error) {
                [listArr removeAllObjects];
                [self makeData];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"拒绝添加%@",error);
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
