//
//  WorkSpaceView.m
//  GuKe
//
//  Created by yb on 2020/11/29.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoView.h"
#import "WorkSpaceInfoViewModel.h"
#import "ExpandTextCell.h"
#import "WorkSpaceHeaderView.h"
#import "WorkSpaceFooter.h"
#import "AllStudiosController.h"
#import "WorkStudioInfoController.h"
#import "CreateWordStudioController.h"

@interface WorkSpaceInfoView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WorkSpaceHeaderView *headerView;
@property (nonatomic, strong) WorkSpaceFooter *footerView;
@property (nonatomic, strong) WorkSpaceInfoViewModel *viewModel;
@property (nonatomic, strong) UIViewController *targetController;

@end

@implementation WorkSpaceInfoView

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

- (void)configareWithTargetController:(UIViewController*)targetController data:(WorkSpaceInfoModel *)data
{
    self.targetController = targetController;
    [self.viewModel configareWithData:data];
    self.headerView.coverImgUrl = self.viewModel.headerImgUrl;
    [self.footerView configureWithTarget:self action:@selector(groupAction:) groups:self.viewModel.groups];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}


- (void)groupAction:(NSString *)groupId
{
    if ([groupId isEqualToString:@"all"]) {
        NSLog(@"查看全部工作室");
        AllStudiosController *vc = [[AllStudiosController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.targetController.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"查看工作室%@",groupId);
        WorkStudioInfoController *vc = [[WorkStudioInfoController alloc] init];
        vc.groupId = groupId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.targetController.navigationController pushViewController:vc animated:YES];
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
        [cell configWithData:self.viewModel.textModel expand:^(BOOL expanded){
            [weakSelf.tableView beginUpdates];
            weakSelf.viewModel.textModel.expanded = expanded;
        
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = IPHONE_Y_SCALE(100);
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

- (WorkSpaceInfoViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[WorkSpaceInfoViewModel alloc] init];
    }
    return _viewModel;
}

- (WorkSpaceHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WorkSpaceHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, IPHONE_Y_SCALE(210))];
    }
    return _headerView;
}

- (WorkSpaceFooter *)footerView
{
    if (!_footerView) {
        _footerView = [[WorkSpaceFooter alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, IPHONE_Y_SCALE(220))];
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
    CreateWordStudioController *vc = [[CreateWordStudioController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.targetController.navigationController pushViewController:vc animated:YES];
}


@end
