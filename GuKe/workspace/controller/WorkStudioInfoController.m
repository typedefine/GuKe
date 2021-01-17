//
//  WorkGroupInfoController.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkStudioInfoController.h"
#import "WorkStudioHeaderView.h"
#import "WorkStudioFooterView.h"
#import "ExpandTextCell.h"
#import "WorkStudioInfoPageModel.h"
#import "ChatViewController.h"
#import "WebViewController.h"

@interface WorkStudioInfoController ()<UITableViewDataSource, UITableViewDelegate, GroupMembersViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WorkStudioHeaderView *headerView;
@property (nonatomic, strong) WorkStudioFooterView *footerView;
@property (nonatomic, strong) WorkStudioInfoPageModel *pageModel;
@property (nonatomic, strong) UIButton *joinButton;

@end

@implementation WorkStudioInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"工作室介绍";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGFloat h = IPHONE_Y_SCALE(40);
    [self.view addSubview:self.joinButton];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-IPHONE_Y_SCALE(10)-SAFE_AREA_BOTTOM);
        make.height.mas_equalTo(h);
    }];
    self.joinButton.clipsToBounds = YES;
    self.joinButton.layer.cornerRadius = h/2.0f;
    [self.joinButton addTarget:self action:@selector(joinButtonAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.groupInfo.joinStatus == 1) {
        self.joinButton.selected = YES;
    }else if(self.groupInfo.joinStatus == 2){
        self.joinButton.enabled = NO;
    }
   
    [self loadServerData];
}

- (void)joinButtonAction
{
    if (self.groupInfo.joinStatus == 0) {
        // 调用:
//        NSString *reason = [NSString stringWithFormat:@"%@申请加入群组",[GuKeCache shareCache].user.name];
//        [[EMClient sharedClient].groupManager requestToJoinPublicGroup:@(self.groupInfo.groupId).stringValue message:reason completion:^(EMGroup *aGroup, EMError *aError) {
//            if (!aError) {
//                NSLog(@"申请加公开群成功 --- %@", aGroup);
//            } else {
//                NSLog(@"申请加公开群失败的原因 --- %@", aError.errorDescription);
//            }
//        }];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_apply_join_studio];
        NSMutableDictionary *paras = [NSMutableDictionary dictionary];
        [paras setValue:@(self.groupInfo.groupId).stringValue forKey:@"groupId"];
        [paras setValue:[GuKeCache shareCache].user.userId forKey:@"userId"];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:paras success:^(id data) {
            NSLog(@"申请加入工作室-->%@",data);
            [self hideHud];
            NSDictionary *dict = (NSDictionary *)data;
            if ([dict[@"retcode"] isEqual:@"0000"]) {
                [self showHint:@"申请加入工作室成功"];
                self.groupInfo.joinStatus = 2;
                self.joinButton.enabled = NO;
            }else{
                [self showHint:dict[@"message"]];
            }
        } failure:^(NSError *error) {
            [self hideHud];
            [self showHint:@"申请加入工作室失败"];
            NSLog(@"申请加入工作室error:%@",error);
        }];
        
    }else if(self.groupInfo.joinStatus == 1){
        if (self.isFromChat) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:@(self.groupInfo.groupId).stringValue conversationType:EMConversationTypeGroupChat];
            chat.hidesBottomBarWhenPushed =YES;
            chat.title = self.groupInfo.groupName;
            [self.navigationController pushViewController:chat animated:YES];
        }
    }
      
}


- (void)loadServerData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_workstudio];
    NSMutableDictionary *para = [@{
        @"sessionId": sessionIding,
        @"groupid":@(self.groupInfo.groupId).stringValue
    } mutableCopy];
   
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        NSLog(@"工作室介绍-->%@",data);
        [self hideHud];
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] isEqual:@"0000"]) {
            [self.pageModel configareWithData:dict[@"data"]];
            self.headerView.title = self.pageModel.name;
            self.headerView.logoUrl = self.pageModel.logoUrl;
            self.footerView.membersView.delegate = self;
            [self.footerView.membersView reloadData];
            self.footerView.supporterView.nameLabel.text = self.pageModel.supporterName;
            [self.footerView.supporterView.logoView sd_setImageWithURL:[NSURL URLWithString:self.pageModel.model.sponsorLogo] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            [self.footerView.supporterView.detailButton addTarget:self action:@selector(supportDetail) forControlEvents:UIControlEventTouchUpInside];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"工作室介绍error:%@",error);
    }];
    
}

/*
- (void)loadServerData
{
    [self.pageModel configareWithData:nil];
//    [self.tableView beginUpdates];
    self.headerView.title = self.pageModel.name;
    self.headerView.logoUrl = self.pageModel.logoUrl;
    self.footerView.membersView.delegate = self;
    [self.footerView.membersView reloadData];
//    [self.footerView.membersView configureWithTarget:self action:@selector(memberAction:) members:self.pageModel.members];
    self.footerView.supporterView.nameLabel.text = @"民安医疗器械有限公司";
    NSString *logoUrl = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2559140773,3124438031&fm=26&gp=0.jpg";
    [self.footerView.supporterView.logoView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    [self.footerView.supporterView.detailButton addTarget:self action:@selector(supportDetail) forControlEvents:UIControlEventTouchUpInside];
//    [self.tableView endUpdates];
//    self.tableView.tableFooterView = self.footerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}
*/
- (void)supportDetail
{
    if (self.pageModel.supporterUrl.isValidStringValue) {
        if (![self.pageModel.supporterUrl hasPrefix:@"http"]) {
            self.pageModel.supporterUrl = [NSString stringWithFormat:@"http://%@",self.pageModel.supporterUrl];
        }
        WebViewController *vc = [[WebViewController alloc] init];
        vc.title = self.pageModel.supporterName;
        vc.url = self.pageModel.supporterUrl;
        [self.navigationController pushViewController:vc animated:YES];
//        [self presentViewController:vc animated:YES completion:nil];
    }
}

//- (void)memberAction:(NSString *)memberId
//{
//    if ([memberId isEqualToString:@"all"]) {
//        NSLog(@"查看全部医生");
//
//    }else{
//        NSLog(@"查看医生%@",memberId);
//    }
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    footer.contentView.backgroundColor = [UIColor whiteColor];
    return footer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==1) {
//        return IPHONE_Y_SCALE(160);
//    }
//    return UITableViewAutomaticDimension;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        typeof(self) weakSelf = self;
        ExpandTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExpandTextCell class])];
        [cell configWithData:self.pageModel.infoCellModel expand:^(BOOL expanded){
            [weakSelf.tableView beginUpdates];
            weakSelf.pageModel.infoCellModel.expanded = expanded;
        
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
           
            [weakSelf.tableView endUpdates];
        }];
        return cell;
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[ExpandTextCell class] forCellReuseIdentifier:NSStringFromClass([ExpandTextCell class])];
        _tableView.sectionHeaderHeight = 50;
        _tableView.sectionFooterHeight = 0.01;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = IPHONE_Y_SCALE(160);
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets=NO;
//            // Fallback on earlier versions
//        }
    }
    return _tableView;
}

- (WorkStudioHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WorkStudioHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, IPHONE_Y_SCALE(80))];
    }
    return _headerView;
}

- (WorkStudioFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[WorkStudioFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, IPHONE_Y_SCALE(280))];
    }
    return _footerView;
}


#pragma mark GroupMembersViewDelegate

- (NSString *)titleInMemberView:(GroupMembersView *)membersView
{
    return @"工作组成员";
}

-(CGSize)itemSizeInMemberView:(GroupMembersView *)membersView
{
    return CGSizeMake(IPHONE_X_SCALE(35), IPHONE_X_SCALE(35));
}

- (CGFloat)minimumLineSpacingInMemberView:(GroupMembersView *)membersView
{
    return IPHONE_Y_SCALE(19);
}

- (CGFloat)minimumInteritemSpacingInMemberView:(GroupMembersView *)membersView
{
    return IPHONE_X_SCALE(25);
}

- (NSArray<UserInfoModel *> *)membersInView:(GroupMembersView *)membersView
{
    return self.pageModel.members;
}

- (void)memberView:(GroupMembersView *)membersView didSelectAtIndex:(NSInteger)index
{
    
}

- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"申请进入" forState:UIControlStateNormal];
        [_joinButton setTitle:@"进入工作室" forState:UIControlStateSelected];
        [_joinButton setTitle:@"已申请加入，等待审核中" forState:UIControlStateDisabled];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _joinButton.backgroundColor = greenC;
    }
    return _joinButton;
}



- (WorkStudioInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkStudioInfoPageModel alloc] init];
        
    }
    return _pageModel;
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

