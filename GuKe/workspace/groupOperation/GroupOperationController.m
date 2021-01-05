//
//  GroupOperationController.m
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupOperationController.h"
#import "GroupOperationPageModel.h"
#import "WorkStudioInfoController.h"
#import "WorkGroupInfoController.h"
#import "CreateWorkGroupController.h"
#import "GroupManageOperationCell.h"
#import "GroupInfoModel.h"

@interface GroupOperationController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GroupOperationPageModel *pageModel;
@end

@implementation GroupOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageModel.items.count;
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
    GroupManageOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupManageOperationCell class])];
    [cell configWithData:self.pageModel.items[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak GroupOperationItemModel *model = self.pageModel.items[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        [weakSelf jumpPage:model];
    }];
}

- (void)jumpPage:(GroupOperationItemModel *)model
{
    switch (model.type) {
        case GroupOperationType_Introduce:
        {
            if (self.groupInfo.groupType == 1) {
                WorkStudioInfoController *vc = [[WorkStudioInfoController alloc] init];
                vc.isFromChat = YES;
                vc.groupInfo = self.groupInfo;
                [self.targetController.navigationController pushViewController:vc animated:NO];
            }else{
                WorkGroupInfoController *vc = [[WorkGroupInfoController alloc] init];
                vc.groupInfo = self.groupInfo;
                [self.targetController.navigationController pushViewController:vc animated:NO];
            }
        }
            break;
            
        case GroupOperationType_Create:
        {
            CreateWorkGroupController *vc = [[CreateWorkGroupController alloc] init];
            vc.superGroupId = @(self.groupInfo.groupId).stringValue;
            [self.targetController.navigationController pushViewController:vc animated:NO];
        }
            break;
            
        case GroupOperationType_memberManage:
        {
            
        }
            break;
            
        case GroupOperationType_Transfer:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.allowsSelection = NO;
        [_tableView registerClass:[GroupManageOperationCell class] forCellReuseIdentifier:NSStringFromClass([GroupManageOperationCell class])];
        _tableView.rowHeight = IPHONE_Y_SCALE(50);
        CGRect f = self.view.bounds;
        f.size.height = IPHONE_X_SCALE(10);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:f];
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

- (GroupOperationPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[GroupOperationPageModel alloc] init];
        _pageModel.isStudio = self.groupInfo.groupType == 1;
    }
    return _pageModel;
}

@end
