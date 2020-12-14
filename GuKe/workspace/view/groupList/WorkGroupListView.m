//
//  WorkGroupListView.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupListView.h"
#import "GroupListCell.h"
#import "GroupListSectionHeaderView.h"
#import "GroupListSectionFooterView.h"
#import "WorkGroupListViewModel.h"
#import "WorkStudioInfoController.h"
#import "WorkGroupInfoController.h"
#import "WYYNewFriendViewController.h"

@interface WorkGroupListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WorkGroupListViewModel *viewModel;
@property (nonatomic, strong) UIViewController *targetController;

@end

@implementation WorkGroupListView

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)configareWithTargetController:(UIViewController*)targetController data:(NSArray *)data
{
    self.targetController = targetController;
    [self.viewModel configareWithData:data];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.groupList.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GroupListSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([GroupListSectionHeaderView class])];
    __weak typeof(self) weakSelf = self;
    [header configWithData:self.viewModel.groupList[section] action:^{
        [weakSelf enterGroupInfoFromSection:section];
    }];
    return header;
}

- (void)enterGroupInfoFromSection:(NSInteger)section
{
    GroupUnionInfoModel *model = self.viewModel.groupList[section];
    WorkStudioInfoController *vc = [[WorkStudioInfoController alloc] init];
    vc.groupId = @(model.ID).stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.targetController.navigationController pushViewController:vc animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GroupListSectionFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([GroupListSectionFooterView class])];
    NSInteger count = self.viewModel.groupList[section].count;
    [footer configWithTarget:self action:@selector(newFriends) newFriendsNum:@(count).stringValue];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.viewModel.groupList[section].count == 0) {
        return 20;
    }
    return IPHONE_Y_SCALE(75);
}

- (void)newFriends
{
    NSLog(@"新申请好友 ");
    WYYNewFriendViewController *vc = [[WYYNewFriendViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.targetController.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.groupList[section].children.count;
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
    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupListCell class])];
    [cell configWithData:self.viewModel.groupList[indexPath.section].children[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfoModel *model = self.viewModel.groupList[indexPath.section].children[indexPath.row];
    WorkGroupInfoController *vc = [[WorkGroupInfoController alloc] init];
    vc.groupId = @(model.ID).stringValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.targetController.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.allowsSelection = NO;
        [_tableView registerClass:[GroupListCell class] forCellReuseIdentifier:NSStringFromClass([GroupListCell class])];
        [_tableView registerClass:[GroupListSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([GroupListSectionHeaderView class])];
        [_tableView registerClass:[GroupListSectionFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([GroupListSectionFooterView class])];
//        _tableView.estimatedSectionFooterHeight = IPHONE_Y_SCALE(65);
//        _tableView.estimatedSectionFooterHeight = IPHONE_Y_SCALE(75);
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = IPHONE_Y_SCALE(50);
        _tableView.sectionHeaderHeight = IPHONE_Y_SCALE(55);
//        _tableView.sectionFooterHeight = IPHONE_Y_SCALE(55);
        _tableView.rowHeight = IPHONE_Y_SCALE(50);
//        _tableView.tableHeaderView = [[UIView alloc] init];
//        _tableView.tableFooterView = [[UIView alloc] init];
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.viewModel.targetController.automaticallyAdjustsScrollViewInsets = NO;
//            // Fallback on earlier versions
//        }
    }
    return _tableView;
}

- (WorkGroupListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[WorkGroupListViewModel alloc] init];
    }
    return _viewModel;
}




@end
