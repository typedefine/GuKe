//
//  WorkGroupsInfoController.m
//  GuKe
//
//  Created by yb on 2020/11/1.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoController.h"
#import "WorkGroupTitleView.h"
#import "WorkSpaceTitleView.h"
#import "WorkSpaceInfoPageModel.h"
#import "WorkSpaceInfoCell.h"
#import "WorkGroupsFooter.h"
#import "AllGroupsController.h"

@interface WorkSpaceInfoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WorkGroupsFooter *footerView;
@property (nonatomic, strong) WorkSpaceInfoPageModel *pageModel;

@end

@implementation WorkSpaceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"工作站";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self loadServerData];
}


//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//}
//- (void)updateViewConstraints
//{
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    [super updateViewConstraints];
//}

- (void)loadServerData
{
    [self.pageModel configareWithData:nil];
    [self.footerView configureWithTarget:self action:@selector(groupAction:) groups:self.pageModel.workGroups];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}
- (void)groupAction:(NSString *)groupId
{
    if ([groupId isEqualToString:@"all"]) {
        NSLog(@"查看全部工作室");
        AllGroupsController *vc = [[AllGroupsController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"查看工作室%@",groupId);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WorkSpaceTitleView class])];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    footer.contentView.backgroundColor = [UIColor whiteColor];
    return footer;
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
        WorkSpaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorkSpaceInfoCell class])];
        [cell configWithData:self.pageModel.workSpaceModel expand:^(BOOL expanded){
            [weakSelf.tableView beginUpdates];
            weakSelf.pageModel.workSpaceModel.expanded = expanded;
        
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
        [_tableView registerClass:[WorkSpaceTitleView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WorkSpaceTitleView class])];
        [_tableView  registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        [_tableView registerClass:[WorkSpaceInfoCell class] forCellReuseIdentifier:NSStringFromClass([WorkSpaceInfoCell class])];
        _tableView.sectionHeaderHeight = 50;
        _tableView.sectionFooterHeight = 0.01;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = IPHONE_Y_SCALE(160);
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

- (WorkGroupsFooter *)footerView
{
    if (!_footerView) {
        _footerView = [[WorkGroupsFooter alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, IPHONE_Y_SCALE(220))];
        __weak typeof(self) weakSelf = self;
        _footerView.titleView.action = ^(){
            [weakSelf addNewGroup];
        };
    }
    return _footerView;
}

- (void)addNewGroup
{
    NSLog(@"申请开通工作室");
}


- (WorkSpaceInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkSpaceInfoPageModel alloc] init];
        
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
