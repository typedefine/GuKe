//
//  GroupAddressbookController.m
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupAddressbookController.h"
#import "GroupAddressbookCell.h"
#import "GroupInfoModel.h"
#import "GroupAddressbookHeaderView.h"
#import "AddMembersController.h"
#import "ChatViewController.h"

@interface GroupAddressbookController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) GroupAddressbookPageModel *pageModel;
@end

@implementation GroupAddressbookController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通讯录";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self loadServerData];
}

- (void)loadServerData
{
    if (self.groupInfo.members &&  self.groupInfo.members.count > 0) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_workstudio];
    NSArray *keysArray = @[@"sessionId",@"groupid"];
    NSArray *valueArray = @[sessionIding,@(self.groupInfo.groupId).stringValue];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            GroupInfoModel *m = [GroupInfoModel mj_objectWithKeyValues:data[@"data"]];
            self.groupInfo.members = m.members;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"群信息%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群信息%@",error);
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupInfo.members.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupAddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupAddressbookCell class])];
    [cell configWithData:self.groupInfo.members[indexPath.row] type:GroupAddressbookCellType_Addressbook];
    __weak typeof(self) weakSelf = self;
    cell.action1 = ^(UserInfoModel * _Nonnull user) {
        [weakSelf chat:user];
    };
    cell.action2 = ^(UserInfoModel * _Nonnull user) {
        [weakSelf addFriend:user];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     UserInfoModel *model = self.groupInfo.members[indexPath.row];
    
}

- (void)chat:(UserInfoModel *)user
{
    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:user.doctorId conversationType:EMConversationTypeChat];
    vc.title = user.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addFriend:(UserInfoModel *)user
{
    NSString *userId = [GuKeCache shareCache].user.userId;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinaddHuan];
    NSArray *keysArray = @[@"sessionId",@"doctorhuanId",@"content"];
    NSArray *valueArray = @[sessionIding,userId,@""];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"好友申请%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            EMError  *error = [[EMClient sharedClient].contactManager addContact:userId message:@"WYY好友申请"];
        }
        [self showHint:data[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"好友申请%@",error);
    }];
}

- (void)addMembers
{
    AddMembersController *vc = [[AddMembersController alloc] init];
    vc.action = InviteMembersActionByAddingFriend;
    __weak typeof(self) weakSelf = self;
    vc.backgroupnumber = ^(NSMutableArray * _Nonnull numberArr) {
        [weakSelf uploadAddMembers:numberArr];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadAddMembers:(NSArray *)data
{
    NSMutableString *uids = [NSMutableString stringWithString:@""];
    for (NSDictionary *item in data) {
        if (uids.length > 0) {
            [uids appendString:@","];
        }
        [uids appendString:item[@"userId"]];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_invite_group_members];
    NSDictionary *paras = @{@"sessionId": [GuKeCache shareCache].sessionId, @"groupid": @(self.groupInfo.groupId).stringValue, @"usernames":uids};
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:paras success:^(id data) {
        [self hideHud];
        [self showHint:data[@"message"]];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            [self loadServerData];
        }
        NSLog(@"邀请入群/添加群成员%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"邀请入群/添加群成员%@",error);
    }];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[GroupAddressbookCell class] forCellReuseIdentifier:NSStringFromClass([GroupAddressbookCell class])];
        _tableView.rowHeight = IPHONE_X_SCALE(60);
        CGRect f = self.view.bounds;
        f.size.height = IPHONE_X_SCALE(50);
        GroupAddressbookHeaderView *header = [[GroupAddressbookHeaderView alloc] initWithFrame:f];
        [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMembers)]];
        _tableView.tableHeaderView = header;
        _tableView.tableFooterView = [[UIView alloc] init];
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.pageModel.targetController.automaticallyAdjustsScrollViewInsets = NO;
//            // Fallback on earlier versions
//        }
    }
    return _tableView;
}

//- (GroupAddressbookPageModel *)pageModel
//{
//    if (!_pageModel) {
//        _pageModel = [[GroupAddressbookPageModel alloc] init];
//    }
//    return _pageModel;
//}

@end
