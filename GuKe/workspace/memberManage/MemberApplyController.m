//
//  WorkGroupMemberApplyController.m
//  GuKe
//
//  Created by yb on 2021/1/24.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "MemberApplyController.h"
#import "GroupAddressbookCell.h"
#import "GroupInfoModel.h"
#import "InvitationManager.h"

@interface MemberApplyController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;

@end

@implementation MemberApplyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友申请";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self loadData];
}

- (void)loadData
{
  
    [self showHudInView:self.view hint:nil];
    NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:[[EMClient sharedClient] currentUsername]];
    for (ApplyEntity *entity in applyArray) {
        NSInteger applyStyle = [entity.style intValue];
        if (applyStyle == 1) {
            
        }
    }
    [self hideHud];
}


- (void)agreeApply:(UserInfoModel *)user
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,group_updateApply];
    NSMutableDictionary *paras = [@{} mutableCopy];
    [paras setValue:[GuKeCache shareCache].sessionId forKey:@"sessionId"];
    [paras setValue:nil forKey:@"groupId"];
    [paras setValue:user.userId forKey:@"userId"];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:paras success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            GroupInfoModel *m = [GroupInfoModel mj_objectWithKeyValues:data[@"data"]];
     
        }else{
            [self showHint:data[@"message"]];
        }
        NSLog(@"群成员%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"群成员%@",error);
    }];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupAddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupAddressbookCell class])];
    [cell configWithData:self.members[indexPath.row] type:GroupAddressbookCellType_MemberApply];
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
