//
//  QJCKFViewcontroller.m
//  GuKe
//
//  Created by MYMAc on 2018/7/17.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "QJCKFViewcontroller.h"
#import "ChatViewController.h"
@interface QJCKFViewcontroller ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTableview;

}

@end

@implementation QJCKFViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线客服";
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
         return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
         return 10;
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
            cell.textLabel.text = [NSString stringWithFormat:@"客服电话：400-99-13559"];
            UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 55,10, 25, 25)];
            img.image =[UIImage imageNamed:@"拨打电话"];
            [cell addSubview:img];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"在线客服"];
            
 
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
         if (indexPath.row == 0) {
             NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-99-13559"];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
             
            }else{
//     与客户聊天  gxs
                
                ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter: @"gxs" conversationType:EMConversationTypeChat];
                chat.doctorId = @"gxs";
                chat.title = @"在线客服";
                chat.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:chat animated:NO];
                

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
