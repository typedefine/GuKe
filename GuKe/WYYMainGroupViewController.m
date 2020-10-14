//
//  WYYMainGroupViewController.m
//  GuKe
//
//  Created by yu on 2018/1/15.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYMainGroupViewController.h"
#import "WYYMainGroupTableViewCell.h"
#import "ChatViewController.h"//聊天页面
#import "WYYChuanjianGroupViewController.h"//创建群组页面

#import "WYYYIshengFriend.h"
#import "WYYFMDBManager.h"
@interface WYYMainGroupViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *groupTableview;
    NSMutableArray *groupArr;
    WYYFMDBManager *GroupManager;
}

@end

@implementation WYYMainGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的群组";
    self.view.backgroundColor = [UIColor whiteColor];
    groupArr = [NSMutableArray array];
    GroupManager = [WYYFMDBManager shareWYYManager];
    
    
    UIBarButtonItem *rightSharBt = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"医生好友_添加"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightSharBt;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeData) name:@"refreshGroupList" object:nil];
    [self makeAddtableview];
    [self makeData];
    // Do any additional setup after loading the view.
}
#pragma mark  导航栏右侧搜索按钮
- (void)onClickedOKbtn {
    WYYChuanjianGroupViewController *group = [[WYYChuanjianGroupViewController alloc]init];
    group.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:group animated:NO];
}
#pragma mark add tableview;
- (void)makeAddtableview{
    groupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)];
    groupTableview.delegate = self;
    groupTableview.dataSource = self;
    groupTableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    groupTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:groupTableview];
}
#pragma mark  我的群列表
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsmygroup];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            groupArr = [NSMutableArray arrayWithArray:data[@"data"]];
            
            for (NSDictionary *dicat in groupArr) {
                WYYYIshengFriend *model = [WYYYIshengFriend yy_modelWithJSON:dicat];
                [GroupManager addFriendListModel:model];
            }
            [groupTableview reloadData];
        }
        NSLog(@"我的群列表%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的群列表%@",error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return groupArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    WYYMainGroupTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WYYMainGroupTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = groupArr[indexPath.row];
    [cellTwo.GroupImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[dic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"医生好友_我的群组"]];
    cellTwo.GroupNameLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"groupname"]];
    
    return cellTwo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = groupArr[indexPath.row];
    ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:[dic objectForKey:@"groupid"] conversationType:EMConversationTypeGroupChat];
    chat.hidesBottomBarWhenPushed =YES;
    chat.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"groupname"]];
    [self.navigationController pushViewController:chat animated:NO];
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
