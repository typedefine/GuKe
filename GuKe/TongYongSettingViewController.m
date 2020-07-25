//
//  TongYongSettingViewController.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "TongYongSettingViewController.h"
#import "ForgetMiMaViewController.h"
#import "LoginViewController.h"
@interface TongYongSettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTableview;
}
@end

@implementation TongYongSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用设置";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self makeAddTableview];
    // Do any additional setup after loading the view from its nib.
}
//返回按钮点击实现方法
-(void)backButtonClick{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
#pragma mark addtableview
- (void)makeAddTableview{
    mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 20;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellTwo= @"cellTwo";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.textColor = SetColor(0x1a1a1a);
        cell.textLabel.font = Font14;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"账户安全"];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"消息提醒"];
            
            UISwitch *pushSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth - 60,4, 80, 40)];
            [pushSwitch addTarget:self action:@selector(didPuchBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:pushSwitch];
            
            EMError *error = nil;
            EMPushOptions *options = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
            if ((options.noDisturbStatus == 0)||(options.noDisturbStatus == 1)){
                [pushSwitch setOn:NO animated:YES];
            }else{
                [pushSwitch setOn:YES animated:YES];
            }
        }
    }else{
        
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 25)];
        labels.textColor = SetColor(0x1a1a1a);
        labels.textAlignment = NSTextAlignmentCenter;
        labels.text = [NSString stringWithFormat:@"退出当前登录"];
        labels.font = Font14;
        [cell.contentView addSubview:labels];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ForgetMiMaViewController *forget = [[ForgetMiMaViewController alloc]init];
            [self presentViewController:forget animated:NO completion:nil];
        }else{
            
        }
    }else{
        
        //退出登录
        EMError *error = nil;
        error = [[EMClient sharedClient] logout:YES];
        if (!error) {
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"passWord"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sessionIdUser"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userPhone"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserId"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"STATE"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"chatImgurl"];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"chatUsername"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
 
            LoginViewController *forget = [[LoginViewController alloc]init];
            [self presentViewController:forget animated:NO completion:nil];
            
        }
        
    }
}
- (void)didPuchBtn:(UISwitch *)sender{
    if (sender.isOn == YES) {
        // 设置全天免打扰，设置后，您将收不到任何推送
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.noDisturbStatus = EMPushNoDisturbStatusClose;
        [[EMClient sharedClient] updatePushNotificationOptionsToServerWithCompletion:^(EMError *aError) {
            if (!aError) {
                NSLog(@"设置成功！");
                [sender setOn:YES animated:YES];
            }else{
                [sender setOn:NO animated:YES];
                NSLog(@"%@",aError.description);
            }
        }];
        
    }else{
        // 设置全天免打扰，设置后，您将收不到任何推送
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.noDisturbStatus = EMPushNoDisturbStatusDay;
        
        [[EMClient sharedClient] updatePushNotificationOptionsToServerWithCompletion:^(EMError *aError) {
            if (!aError) {
                [sender setOn:NO animated:YES];
                NSLog(@"设置成功！");
            }else{
                [sender setOn:YES animated:YES];
                NSLog(@"%@",aError.description);
            }
        }];
        
    }
    
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
