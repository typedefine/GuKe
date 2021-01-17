//
//  GroupAddressbookController.m
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupAddressbookController.h"
#import "GroupAddressbookPageModel.h"
#import "GroupAddressbookCell.h"
#import "GroupInfoModel.h"
#import "GroupAddressbookHeaderView.h"
#import "AddMembersController.h"

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
    }else{
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsgroupinfo];
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
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupInfo.members.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.section==1) {
////        return IPHONE_Y_SCALE(160);
////    }
//    return UITableViewAutomaticDimension;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupAddressbookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupAddressbookCell class])];
    [cell configWithData:self.groupInfo.members[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     UserInfoModel *model = self.groupInfo.members[indexPath.row];
    
}


- (void)addMembers
{
    AddMembersController *vc = [[AddMembersController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
