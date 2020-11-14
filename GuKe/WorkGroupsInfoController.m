//
//  WorkGroupsInfoController.m
//  GuKe
//
//  Created by yb on 2020/11/1.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupsInfoController.h"
#import "WorkGroupTitleView.h"
#import "WorkSpaceTitleView.h"
#import "WorkGroupsInfoPageModel.h"
#import "WorkSpaceInfoCell.h"
#import "WorkGroupsCell.h"

@interface WorkGroupsInfoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WorkGroupsInfoPageModel *pageModel;

@end

@implementation WorkGroupsInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"工作站";
    
    [self.view addSubview:self.tableView];

    [self loadServerData];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
//- (void)updateViewConstraints
//{
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    [super updateViewConstraints];
//}

- (void)loadServerData
{
    self.pageModel.workSpaceModel.imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604341757216&di=d47d72d001fabb898f52859b93dd1f10&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fa3b34c7c69524635b916514f73a6a09b68220bb61fcc4-1QPL3D_fw658";
    self.pageModel.workSpaceModel.content = @"骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    if (section == 0) {
        WorkSpaceTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WorkSpaceTitleView class])];
        view.title = self.pageModel.workSpacetitle;
        return view;
    }else{
        WorkGroupTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([WorkGroupTitleView class])];
        view.title = self.pageModel.workGrouptitle;
        view.subTitle = self.pageModel.addGroupActionTitle;
        __weak typeof(self) weakSelf = self;
        view.action = ^{
            [weakSelf addNewGroup];
        };
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    footer.contentView.backgroundColor = [UIColor whiteColor];
    return footer;
}



- (void)addNewGroup
{
    NSLog(@"申请开通工作室");
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WorkSpaceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorkSpaceInfoCell class])];
        [cell configWithData:self.pageModel.workSpaceModel];
        return cell;
    }else{
        WorkGroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorkGroupsCell class])];
        
        return cell;
    }
}




- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.allowsSelection = NO;
        [_tableView registerClass:[WorkSpaceTitleView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WorkSpaceTitleView class])];
        [_tableView registerClass:[WorkGroupTitleView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([WorkGroupTitleView class])];
        [_tableView  registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        [_tableView registerClass:[WorkGroupsCell class] forCellReuseIdentifier:NSStringFromClass([WorkGroupsCell class])];
        [_tableView registerClass:[WorkSpaceInfoCell class] forCellReuseIdentifier:NSStringFromClass([WorkSpaceInfoCell class])];
        _tableView.sectionHeaderHeight = 50;
        _tableView.sectionFooterHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.tableFooterView = [[UIView alloc] init];
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets=NO;
//            // Fallback on earlier versions
//        }
    }
    return _tableView;
}

- (WorkGroupsInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkGroupsInfoPageModel alloc] init];
        
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
