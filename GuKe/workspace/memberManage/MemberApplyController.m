//
//  WorkGroupMemberApplyController.m
//  GuKe
//
//  Created by yb on 2021/1/24.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "MemberApplyController.h"
#import "GroupApplyCell.h"
#import "InvitationManager.h"

@interface MemberApplyController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ApplyEntity *> *applyEntities;

@end

@implementation MemberApplyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加入工作室/组申请";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self loadData];
}

- (void)loadData
{
    self.applyEntities = [NSMutableArray array];
    [self showHudInView:self.view hint:nil];
    NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:[[EMClient sharedClient] currentUsername]];
    if (applyArray) {
        [self.applyEntities addObjectsFromArray:applyArray];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
//        for (ApplyEntity *entity in applyArray) {
//            NSInteger applyStyle = [entity.style intValue];
//            if (applyStyle == 1) {
//
//            }
            
//        }
    }
    [self hideHud];
}


- (void)agreeApply:(UserInfoModel *)user
{
  
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applyEntities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = self.applyEntities[indexPath.row];
    GroupApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupApplyCell class])];
    cell.titleLabel.text = [entity.reason componentsSeparatedByString:@"："].lastObject;
    cell.acceptButton.tag = cell.refuseButton.tag = indexPath.row+999;
    [cell.acceptButton addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
    [cell.refuseButton addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)accept:(UIButton *)btn
{
    ApplyEntity *entity = self.applyEntities[btn.tag-999];
    
    
    [[EMClient sharedClient].groupManager approveJoinGroupRequest:entity.groupId sender:[GuKeCache shareCache].user.userId completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            NSLog(@"批准入群申请成功 --- %@", aGroup);
            NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,group_updateApply];
            NSMutableDictionary *paras = [@{} mutableCopy];
            [paras setValue:[GuKeCache shareCache].sessionId forKey:@"sessionId"];
            [paras setValue:nil forKey:@"groupId"];
            [paras setValue:[GuKeCache shareCache].user.userId forKey:@"userId"];
            [self showHudInView:self.view hint:nil];
            [ZJNRequestManager postWithUrlString:urlString parameters:paras success:^(id data) {
                [self hideHud];
                NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
                if ([retcode isEqualToString:@"0000"]) {
                    [self showHint:data[@"message"]];
                    [self.applyEntities removeObject:entity];
                    [self.tableView reloadData];
                }
                NSLog(@"同意申请加入工作室%@",data);
            } failure:^(NSError *error) {
                [self hideHud];
                NSLog(@"同意申请加入工作室%@",error);
            }];
        } else {
            NSLog(@"批准入群申请失败的原因 --- %@", aError.errorDescription);
        }
    }];
}

- (void)refuse:(UIButton *)btn
{
//    ApplyEntity *entity = self.applyEntities[btn.tag-999];
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[GroupApplyCell class] forCellReuseIdentifier:NSStringFromClass([GroupApplyCell class])];
        _tableView.rowHeight = IPHONE_X_SCALE(60);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


@end
