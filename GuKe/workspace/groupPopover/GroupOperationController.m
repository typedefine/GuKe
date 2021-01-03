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
//    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GroupListCell class])];
//    [cell configWithData:self.pageModel.groupList[indexPath.section].chatroom[indexPath.row]];
//    return cell;
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isStudio) {
        WorkStudioInfoController *vc = [[WorkStudioInfoController alloc] init];
        vc.groupId = self.groupId;
        [self.targetController.navigationController pushViewController:vc animated:NO];
    }else{
        WorkGroupInfoController *vc = [[WorkGroupInfoController alloc] init];
        vc.groupId = self.groupId;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.allowsSelection = NO;
//        [_tableView registerClass:[GroupListCell class] forCellReuseIdentifier:NSStringFromClass([GroupListCell class])];
        _tableView.rowHeight = IPHONE_Y_SCALE(40);
//        _tableView.tableHeaderView = [[UIView alloc] init];
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
    }
    return _pageModel;
}




@end
