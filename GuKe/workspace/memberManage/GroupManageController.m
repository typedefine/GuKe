//
//  GroupManageController.m
//  GuKe
//
//  Created by yb on 2021/1/19.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupManageController.h"
#import "GroupAddressbookCell.h"
#import "GroupInfoModel.h"
#import "ManageRightPopupView.h"
#import "ManageRightPopupCellModel.h"

@interface GroupManageController ()<UITableViewDataSource, UITableViewDelegate, ManageRightPopupViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@property (nonatomic, strong) ManageRightPopupView *popupView;
@property(nonatomic, strong) NSArray<ManageRightPopupCellModel *> *actionList;

@end

@implementation GroupManageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"成员管理";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self loadServerData];
}

- (void)loadServerData
{
    if (self.groupInfo.members &&  self.groupInfo.members.count > 0) {
        [self handlerManagerMembers];
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
            [self handlerManagerMembers];
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"群成员%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群成员%@",error);
    }];
}

- (void)handlerManagerMembers
{
    NSMutableArray *list = [NSMutableArray array];
    UserInfoModel *selfUser = [GuKeCache shareCache].user;
    for (UserInfoModel *u in self.groupInfo.members) {
        if ([u.doctorId isEqualToString:selfUser.doctorId]) {
            continue;
        }
        [list addObject:u];
    }
    self.members = [list copy];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupAddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupAddressbookCell class])];
    [cell configWithData:self.members[indexPath.row] type:GroupAddressbookCellType_Manage];
    __weak typeof(self) weakSelf = self;
    cell.action1 = ^(UserInfoModel * _Nonnull user) {
        [weakSelf manage:user];
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     UserInfoModel *model = self.groupInfo.members[indexPath.row];
    
}


- (void)manage:(UserInfoModel *)user
{
    self.popupView.extra = user;
    [self.popupView show];
}

- (void)popupView:(ManageRightPopupView *)popupView didSelectAtIndx:(NSUInteger)index
{
    UserInfoModel *user = popupView.extra;
    ManageRightPopupCellModel *m = self.actionList[index];
    NSString *roleName = [m.title replace:@"设为" withString:@""];
    NSString *urlString = nil;
    NSMutableDictionary *paras = [@{} mutableCopy];
    [paras setValue:[GuKeCache shareCache].sessionId forKey:@"sessionId"];
    [paras setValue:@(self.groupInfo.groupId).stringValue forKey:@"groupId"];
    [paras setValue:user.userId forKey:@"userId"];
    
    switch (index) {
        case 0:
        case 1:
        {
            urlString = [NSString stringWithFormat:@"%@%@",requestUrl,groupIDLabel];
            NSInteger roleType = index+1;
            [paras setValue:@(roleType) forKey:@"roleType"];
//            if (self.groupInfo.groupType == 1) {
//                roleName = @[@"管理员", @"会长/秘书长"][index];
//            }else{
//                roleName = @[@"组长", @"核心成员"][index];
//            }
            [paras setValue:roleName forKey:@"roleName"];
        }
            break;
        case 2:
        {
            urlString = [NSString stringWithFormat:@"%@%@",requestUrl,group_mute];
            
        }
            break;
            
        case 3:
        {
            urlString = [NSString stringWithFormat:@"%@%@",requestUrl,addgroupblack];
        }
            break;
            
        case 4:
        {
            urlString = [NSString stringWithFormat:@"%@%@",requestUrl,group_remove_members];
            [paras setValue:user.userId forKey:@"usernames"];//可同时设置多个用户，以","相隔
        }
            break;
            
        default:
            break;
    }
    
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:paras success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            if (index <= 1) {
                user.roleName = roleName;
                user.roleType = index + 1;
                [self.tableView reloadData];
            }else{
                [self showHint:data[@"message"]];
            }
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"群成员管理%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群成员管理%@",error);
    }];
    
    
}

- (NSArray<ManageRightPopupCellModel *> *)itemsForPopupView:(ManageRightPopupView *)popupView
{
    return self.actionList;
}

- (ManageRightPopupView *)popupView
{
    if (!_popupView) {
        _popupView = [[ManageRightPopupView alloc] initWithDelegate:self];
    }
    return _popupView;
}

- (NSArray<ManageRightPopupCellModel *> *)actionList
{
    if (!_actionList) {
        NSArray *titles = @[@"设为组长", @"设为核心成员", @"禁言", @"移入黑名单", @"踢人"];
        NSMutableArray<ManageRightPopupCellModel *> *list = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i=0; i<titles.count; i++) {
            ManageRightPopupCellModel *m = [[ManageRightPopupCellModel alloc] init];
            m.title = titles[i];
            m.alert = i>1;
            [list addObject:m];
        }
        if (self.groupInfo.groupType == 1) {
            list[0].title = @"设为管理员";
            list[1].title = @"设为会长/秘书长";
        }
        _actionList = [list copy];
    }
    return _actionList;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[GroupAddressbookCell class] forCellReuseIdentifier:NSStringFromClass([GroupAddressbookCell class])];
        _tableView.rowHeight = IPHONE_X_SCALE(60);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


@end
