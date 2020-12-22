//
//  CreateWordStudioController.m
//  GuKe
//
//  Created by saas on 2020/12/21.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "CreateWordStudioController.h"
#import "ZXFInputFieldCell.h"
#import "ZXFInputImageCell.h"
#import "ZXFInputViewCell.h"
#import "CreateWordStudioPageModel.h"

@interface CreateWordStudioController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CreateWordStudioPageModel *pageModel;

@end

@implementation CreateWordStudioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    
}

- (void)addSubViews
{
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.allowsSelection = NO;
        _table.tableFooterView = [[UIView alloc] init];
        [_table registerClass:[ZXFInputFieldCell class] forCellReuseIdentifier:NSStringFromClass([ZXFInputFieldCell class])];
        [_table registerClass:[ZXFInputImageCell class] forCellReuseIdentifier:NSStringFromClass([ZXFInputImageCell class])];
        [_table registerClass:[ZXFInputViewCell class] forCellReuseIdentifier:NSStringFromClass([ZXFInputViewCell class])];
    }
    return _table;
}

- (CreateWordStudioPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[CreateWordStudioPageModel alloc] init];
        
    }
    return _pageModel;
}

@end
