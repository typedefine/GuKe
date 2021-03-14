//
//  WYYGroupDetailViewController.m
//  GuKe
//
//  Created by yu on 2018/1/16.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYGroupDetailViewController.h"
#import "WYYQunLiaoOneTableViewCell.h"
#import "WYYQunLiaoTwoTableViewCell.h"
#import "WYYChoseGroupNumberViewController.h"//选择群成员列表
#import "WYYAllGroupNumberViewController.h"//所有群成员列表
@interface WYYGroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *qunliaoTableview;
    NSArray *titleArr;
    NSMutableArray *personArr;//存放群成员
    NSDictionary *groupDic;
    CGRect gonggaoHeight;
    BOOL isGroupManger;//是否是管理员
    BOOL isTuiSong;//是否设置消息免打扰
    NSArray *arrasy;//存放所有群组成员
    
}

@end

@implementation WYYGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群聊详情";
    self.view.backgroundColor = [UIColor whiteColor];
    personArr = [NSMutableArray array];
    
    titleArr = @[@"群组名称",@"",@"消息免打扰",@"查看聊天记录",@"清除聊天记录"];
    
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.groupID completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            self.group =aGroup;
            isTuiSong = self.group.isPushNotificationEnabled;
            [qunliaoTableview reloadData];
        }
        [self hideHud];
        
    }];
    
    [self makeaddtableview];
    [self makeData];
    // Do any additional setup after loading the view.
}

#pragma mark add tableview
-(void)makeaddtableview{
    if (IS_IPGONE_X) {
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 86)];
    }else{
        qunliaoTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    }
    
    [self.view addSubview:qunliaoTableview];
    qunliaoTableview.delegate = self;
    qunliaoTableview.dataSource = self;
    qunliaoTableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    qunliaoTableview.tableFooterView = [[UIView alloc]init];
}
#pragma mark  群信息
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsgroupinfo];
    NSArray *keysArray = @[@"sessionId",@"groupid"];
    NSArray *valueArray = @[sessionIding,self.groupID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            groupDic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            arrasy = [NSArray arrayWithArray:data[@"data"][@"members"]];
            if (arrasy.count > 5) {
                for (int a = 0; a < 5; a ++ ) {
                    [personArr addObject:arrasy[a]];
                }
                
            }else{
                [personArr addObjectsFromArray:arrasy];
            }
            
            
            NSString *currentUserName = [[EMClient sharedClient] currentUsername];
            
            if ([currentUserName isEqualToString:[groupDic objectForKey:@"owner"]]) {
                isGroupManger = YES;
            }else{
                isGroupManger = NO;
            }
            
        }else{
            [self showHint:data[@"message"]];
        }
        [qunliaoTableview reloadData];
        NSLog(@"群信息%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群信息%@",error);
    }];
}
#pragma mark 退出群
- (void)tuichuGroup{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsleavegroup];
    NSArray *keysArray = @[@"sessionId",@"groupid"];
    NSArray *valueArray = @[sessionIding,self.groupID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"退出群%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"退出群%@",error);
    }];
}
#pragma mark 解散群
- (void)jiesanGroup{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsdelete];
    NSArray *keysArray = @[@"sessionId",@"groupid"];
    NSArray *valueArray = @[sessionIding,self.groupID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"解散群%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"解散群%@",error);
    }];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
    
        return gonggaoHeight.size.height + 40;
    }else{
        return 44;
    }
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
   return  30 + 80 * (int)(arrasy.count +1 +1)/6  + 20;
    
//    if (arrasy.count > 5) {
//        return 190 + 20;
//    }else if (personArr.count == 0) {
//        return 110;
//    }else if (personArr.count%6 == 0) {
//        return 80 * (personArr.count + 1)/6 + 30;
//    }else{
//        return 80 * ((personArr.count + 1)/6 + 1) + 30;
//    }
//
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80 * (personArr.count + 1)/6 + 30)];
    whiteView.backgroundColor = [UIColor whiteColor];
    if (arrasy.count > 5) {
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 210);
    }else if (personArr.count == 0) {
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 110);
    }else if (personArr.count%6 == 0) {
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 80 * (personArr.count + 1)/6 + 30);
    }else{
        whiteView.frame = CGRectMake(0, 0, ScreenWidth, 80 * ((personArr.count + 1)/6 + 1) + 30);
    }
    UILabel *labesl = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 200, 14)];
    labesl.tag = 100;
    labesl.font = [UIFont systemFontOfSize:14];
    labesl.textColor = SetColor(0x1A1A1A);
    labesl.text = [NSString stringWithFormat:@"多人聊天成员（%ld人）",personArr.count];
    [whiteView addSubview:labesl];
    
    for (int a = 0; a < personArr.count + 1 ; a ++) {
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth/6 - 43)/2 + ScreenWidth/6* (a%6), 40 + 70 * (a/6), 43, 43)];
        images.tag = a;
        images.layer.masksToBounds = YES;
        images.layer.cornerRadius = 21.5;
        [whiteView addSubview:images];
        
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth/6 - 43)/2+ 43 + ScreenWidth/6* (a%6) - 10, 40 + 70 * (a/6) - 10, 20, 20)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"ɾ"] forState:normal];
        deleteBtn.tag = a;
        [deleteBtn addTarget:self action:@selector(didNumber:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:deleteBtn];
        
        
        
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0+ a * ScreenWidth/6, CGRectGetMaxY(images.frame)+ 5 +  70 * (a/6), ScreenWidth/6, 20)];
        nameLab.textColor = greenC;
        nameLab.tag = a;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:12];
        [whiteView addSubview:nameLab];
        if (a == personArr.count) {
            images.image = [UIImage imageNamed:@"添加图片"];
            [Utile addClickEvent:self action:@selector(didAddGroupNumber) owner:images];
            nameLab.text = @"邀请";
            deleteBtn.hidden = YES;
        }else{
            [images sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,personArr[a][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
            nameLab.text = [NSString stringWithFormat:@"%@",personArr[a][@"name"]];
        }
        
    }
    
    if (arrasy.count > 5) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0, 190, ScreenWidth, 20)];
        [btns setTitle:@"查看更多群成员" forState:normal];
        btns.titleLabel.font = [UIFont systemFontOfSize:14];
        [btns addTarget:self action:@selector(didMoreGroupnumber) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btns];
    }
    
    return whiteView;
}
#pragma mark 查看更多群成员
- (void)didMoreGroupnumber{
    WYYAllGroupNumberViewController *all = [[WYYAllGroupNumberViewController alloc]init];
    all.hidesBottomBarWhenPushed = YES;
    all.groupArr = arrasy;
    [self.navigationController pushViewController:all animated:NO];
}
#pragma mark 删除群成员
- (void)didNumber:(UIButton *)sender{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsdeletegroup];
    NSArray *keysArray = @[@"sessionId",@"groupid",@"usernames"];
    NSArray *valueArray = @[sessionIding,self.groupID,personArr[sender.tag][@"userid"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [personArr removeObjectAtIndex:sender.tag];
            [qunliaoTableview reloadData];
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"群主移除群成员%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群主移除群成员%@",error);
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(10, 150, ScreenWidth - 20, 44)];
    btns.backgroundColor = greenC;
    if (isGroupManger) {
        [btns setTitle:@"解散群组" forState:normal];
    }else{
        [btns setTitle:@"删除并退出" forState:normal];
    }
    
    [btns setTitleColor:[UIColor whiteColor] forState:normal];
    [backView addSubview:btns];
    btns.layer.masksToBounds = YES;
    btns.layer.cornerRadius = 22;
    [btns addTarget:self action:@selector(deleteGroup) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btns];
    
    return backView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
        static NSString *cellIdone = @"cellIdone";
        WYYQunLiaoTwoTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
        if (!cellOne) {
            cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYQunLiaoTwoTableViewCell" owner:self options:nil] lastObject];
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellOne.groupMiaoShuLab.frame = CGRectMake(16, 33, ScreenWidth - 32, 0);
        cellOne.groupMiaoShuLab.text = [NSString stringWithFormat:@"%@",[groupDic objectForKey:@"desc"]];
        gonggaoHeight = [cellOne.groupMiaoShuLab boundingRectWithInitSize:cellOne.groupMiaoShuLab.frame.size];
        cellOne.groupMiaoShuLab.frame = CGRectMake(16, 33, ScreenWidth - 32, gonggaoHeight.size.height);
        return cellOne;
        
    }else{
        static NSString *cellIdone = @"cellIdone";
        WYYQunLiaoOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
        if (!cellOne) {
            cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYQunLiaoOneTableViewCell" owner:self options:nil] lastObject];
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellOne.titleLab.text = titleArr[indexPath.row];
        if (indexPath.row == 0) {
            cellOne.detailLab.text = [NSString stringWithFormat:@"%@",[groupDic objectForKey:@"groupname"]];
            cellOne.detailLab.hidden = NO;
            cellOne.swBtn.hidden = YES;
        }else if (indexPath.row == 2){
            cellOne.detailLab.hidden = YES;
            cellOne.swBtn.hidden = NO;
            [cellOne.swBtn addTarget:self action:@selector(didMianDaRao:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isTuiSong) {
                cellOne.swBtn.on = NO;
            }else{
                cellOne.swBtn.on = YES;
            }
            
        }else if (indexPath.row == 3){
            cellOne.detailLab.hidden = YES;
            cellOne.swBtn.hidden = YES;
        }else{
            cellOne.detailLab.hidden = YES;
            cellOne.swBtn.hidden = YES;
        }
        return cellOne;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清除聊天记录吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"点击了确定按钮");
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:self.groupID];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark 删除群组
- (void)deleteGroup{
    if (isGroupManger) {
        [self jiesanGroup];
    }else{
        [self tuichuGroup];
    }
}
#pragma mark 消息免打扰
- (void)didMianDaRao:(UISwitch *)swbtn{
    if (isGroupManger) {
        [self showHint:@"管理员不能屏蔽群消息！"];
        [swbtn setOn:NO];
        return;
    }
    
    
    if (!swbtn.isOn) {
        [[EMClient sharedClient].groupManager blockGroup:self.groupID completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                [self showHint:@"设置成功！"];
            }else{
                [self showHint:@"设置失败！"];
            }
        }];
        
    }else{
        [[EMClient sharedClient].groupManager unblockGroup:self.groupID completion:^(EMGroup *aGroup, EMError *aError) {
            if (!aError) {
                [self showHint:@"设置成功！"];
            }else{
                [self showHint:@"设置失败！"];
            }
        }];
    }
}
#pragma mark 添加群成员
- (void)didAddGroupNumber{
    WYYChoseGroupNumberViewController *group = [[WYYChoseGroupNumberViewController alloc]init];
    group.style = 1;
    group.hidesBottomBarWhenPushed = YES;
    group.GroupNumberArr = personArr;
    group.backaddnumber = ^(NSMutableArray *numberArr) {
        
        NSLog(@"%@",numberArr);
        
        NSMutableArray *arrayOne = [NSMutableArray array];
//        for (int a = 0; a < groupArr.count ; a ++ ) {
        for (NSDictionary * dic in numberArr) {
            
//            真几把乱这些字段
            if(!dic[@"userid"]){
                [arrayOne addObject:dic[@"userId"]];
            }
        }
        
        if (arrayOne.count == 0) {
            
        }else{
            NSString *stringOne = [arrayOne componentsJoinedByString:@","];
            [self addGroupNumber:stringOne];
        }
        
        
        //[groupTableview reloadData];
    };
    [self.navigationController pushViewController:group animated:NO];
    
}
#pragma mark 添加群成员
- (void)addGroupNumber:(NSString *)groupStr{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsaddgroup];
    NSArray *keysArray = @[@"sessionId",@"groupid",@"usernames"];
    NSArray *valueArray = @[sessionIding,self.groupID,groupStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [personArr removeAllObjects];
            [self makeData];
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"添加群成员%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"添加群成员%@",error);
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
