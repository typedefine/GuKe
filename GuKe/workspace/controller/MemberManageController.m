//
//  MemberManageController.m
//  GuKe
//
//  Created by saas on 2020/12/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "MemberManageController.h"
#import "MemberManageCell.h"
#import "MemberManagePageModel.h"

@interface MemberManageController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) MemberManagePageModel *pageModel;

@end

@implementation MemberManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成员管理";
    
    [self addSubviews];
    [self loadServerData];
}

- (void)addSubviews
{
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadServerData
{
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageModel.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberManageCell class])];
    [cell configWithData:self.pageModel.members[indexPath.row]];
    return cell;
}


- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] init];
        [_table registerClass:[MemberManageCell class] forCellReuseIdentifier:NSStringFromClass([MemberManageCell class])];
        _table.rowHeight = 44;
        _table.tableFooterView = [[UIView alloc] init];
    }
    return _table;
}

- (MemberManagePageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[MemberManagePageModel alloc] init];
    }
    return _pageModel;
}


@end
