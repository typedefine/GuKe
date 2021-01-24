//
//  RemoveRightController.m
//  GuKe
//
//  Created by yb on 2021/1/19.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "RemoveRightController.h"
#import "GroupAddressbookCell.h"
#import "GroupInfoModel.h"

@interface RemoveRightController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *naviRightButton;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@end

@implementation RemoveRightController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x3C3E3D];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3C3E3D],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = greenC;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        // Fallback on earlier versions
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"移交管理权限";
    self.selectedIndex = -1;
    self.members = @[];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
    [self.naviRightButton addTarget:self action:@selector(naviRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self loadServerData];
}

- (void)naviRightButtonAction
{
    if (self.selectedIndex < 0){
        [self showHint:@"请选择要移交管理权限的对象"];
        return;
    }
    
    UserInfoModel *user = self.members[self.selectedIndex];
    if ([user.doctorId isEqualToString:[GuKeCache shareCache].user.doctorId]) {
        [self showHint:@"请选择其他对象移交管理权限"];
        return;
    }

    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,group_addMangeright];;
    NSMutableDictionary *paras = [@{} mutableCopy];
    [paras setValue:[GuKeCache shareCache].sessionId forKey:@"sessionId"];
    [paras setValue:@(self.groupInfo.groupId).stringValue forKey:@"groupId"];
    [paras setValue:user.userId forKey:@"userId"];//可同时设置多个用户，以","相隔
    
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:paras success:^(id data) {
        [self hideHud];
        NSLog(@"群成员管理%@",data);
       
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            self.selectedIndex = -1;
            user.roleType = 1;
            user.roleName = self.groupInfo.groupType==1?@"管理员":@"组长";
            [self.tableView reloadData];
//            [self loadServerData];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) weakSelf = self;
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf popBack];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
//            [self performSelector:@selector(popBack) withObject:nil afterDelay:2];
        }else{
            [self showHint:data[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群成员管理%@",error);
    }];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
        NSLog(@"群信息%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群信息%@",error);
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
    [cell configWithData:self.members[indexPath.row] type:self.selectedIndex==indexPath.row?GroupAddressbookCellType_RemoveRightSelected:GroupAddressbookCellType_RemoveRightUnselected];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selected = self.selectedIndex == indexPath.row;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     UserInfoModel *model = self.groupInfo.members[indexPath.row];
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.allowsSelection = NO;
        [_tableView registerClass:[GroupAddressbookCell class] forCellReuseIdentifier:NSStringFromClass([GroupAddressbookCell class])];
        _tableView.rowHeight = IPHONE_X_SCALE(55);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIButton *)naviRightButton
{
    if (!_naviRightButton) {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _naviRightButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_naviRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_naviRightButton setTitle:@"完成" forState:UIControlStateNormal];//@"查找群"
        _naviRightButton.backgroundColor = greenC;
        CGFloat h = IPHONE_Y_SCALE(25);
        _naviRightButton.frame = CGRectMake(0, 0, IPHONE_X_SCALE(60), h);
        _naviRightButton.layer.cornerRadius = h/2.0f;
    }
    return _naviRightButton;
}

@end
