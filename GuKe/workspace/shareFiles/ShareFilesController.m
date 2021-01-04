//
//  ShareFilesController.m
//  GuKe
//
//  Created by yb on 2021/1/5.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "ShareFilesController.h"
#import "ShareFilesPageModel.h"
#import "ShareFileCell.h"

@interface ShareFilesController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ShareFilesPageModel *pageModel;
@end

@implementation ShareFilesController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self headerRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)loadFileData
{
    [[EMClient sharedClient].groupManager getGroupFileListWithId:self.groupId pageNumber:self.pageModel.curPage pageSize:self.pageModel.pageSize completion:^(NSArray *aList, EMError *aError) {
        if(!aError){
            // aList数组里面是 EMGroupSharedFile 对象
            NSLog(@"获取群共享文件列表成功 --- %@", aList);
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadData];
        } else {
            NSLog(@"获取群共享文件列表失败的原因 --- %@", aError.errorDescription);
        }
    }];
}

- (void)headerRefresh
{
    self.pageModel.curPage = 1;
    [self loadFileData];
}


- (void)footerLoadMore
{
    self.pageModel.curPage++;
    [self loadFileData];
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
    ShareFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShareFileCell class])];
    [cell configWithData:self.pageModel.items[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ShareFileItemModel *model = self.pageModel.items[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-TabbarHeight)
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.allowsSelection = NO;
        [_tableView registerClass:[ShareFileCell class] forCellReuseIdentifier:NSStringFromClass([ShareFileCell class])];
        _tableView.rowHeight = IPHONE_X_SCALE(60);
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

- (ShareFilesPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[ShareFilesPageModel alloc] init];
    }
    return _pageModel;
}

@end
