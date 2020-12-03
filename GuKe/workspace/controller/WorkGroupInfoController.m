//
//  WorkGroupInfoController.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupInfoController.h"
#import "WorkGroupHeaderView.h"
#import "WorkGroupFooterView.h"
#import "ExpandTextCell.h"
#import "WorkGroupInfoPageModel.h"

@interface WorkGroupInfoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WorkGroupHeaderView *headerView;
@property (nonatomic, strong) WorkGroupFooterView *footerView;
@property (nonatomic, strong) WorkGroupInfoPageModel *pageModel;
@property (nonatomic, strong) UIButton *joinButton;

@end

@implementation WorkGroupInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"工作站";
    
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

    [self loadServerData];
}

- (void)joinButtonAction
{
    
}

- (void)loadServerData
{
    [self.pageModel configareWithData:nil];
    self.headerView.title = self.pageModel.name;
    self.headerView.logoUrl = self.pageModel.logoUrl;
    [self.footerView.membersview configureWithTarget:self action:@selector(memberAction:) members:self.pageModel.members];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}
- (void)memberAction:(NSString *)memberId
{
    if ([memberId isEqualToString:@"all"]) {
        NSLog(@"查看全部工作室");
      
    }else{
        NSLog(@"查看工作室%@",memberId);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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

- (WorkGroupHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WorkGroupHeaderView alloc] init];
    }
    return _headerView;
}

- (WorkGroupFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[WorkGroupFooterView alloc] init];//WithFrame:CGRectMake(0, 0, ScreenWidth, IPHONE_Y_SCALE(220))
    }
    return _footerView;
}

- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitle:@"申请进入" forState:UIControlStateNormal];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _joinButton.backgroundColor = greenC;
    }
    return _joinButton;
}



- (WorkGroupInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkGroupInfoPageModel alloc] init];
        
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

