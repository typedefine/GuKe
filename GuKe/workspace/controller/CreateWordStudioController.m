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
@property (nonatomic, strong) UIButton *createStudioButton;
@end

@implementation CreateWordStudioController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
}

- (void)addSubViews
{
    self.title = @"申请开通工作室";
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table reloadData];
    
    CGFloat h = IPHONE_X_SCALE(40);
    [self.view addSubview:self.createStudioButton];
    [self.createStudioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(IPHONE_X_SCALE(20));
        make.right.equalTo(self.view).offset(-IPHONE_X_SCALE(20));
        make.height.mas_equalTo(h);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    self.createStudioButton.clipsToBounds = YES;
    self.createStudioButton.layer.cornerRadius = h/2.0f;
    [self.createStudioButton addTarget:self action:@selector(createWorkStudio) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createWorkStudio
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageModel.cellModelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.pageModel.cellModelList[indexPath.row].height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block ZXFInputCellModel *m = self.pageModel.cellModelList[indexPath.row];
//    __weak typeof(self) weakSelf = self;
//    __weak NSIndexPath *weakIndexPath = indexPath;
    switch (m.cellType) {
        case ZXFInputCellTypeImagePick:
        {
            ZXFInputImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputImageCell class])];
            [cell configureWithTarget:self title:m.title indicate:m.placeholder completion:^(id  _Nonnull data) {
                m.content = data;
            }];
            return cell;
        }
        
        case ZXFInputCellTypeTextView:
        {
            ZXFInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputViewCell class])];
            [cell configureWithTitle:m.title content:m.content input:^(NSString * _Nonnull text) {
//                [weakSelf.table scrollToRowAtIndexPath:weakIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                m.content = text;
            }];
            return cell;
        }
            
        default:
        {
            ZXFInputFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputFieldCell class])];
            [cell configWithTitle:m.title placeholder:m.placeholder completion:^(NSString * _Nonnull text) {
//                if (weakIndexPath.row >= weakSelf.pageModel.cellModelList.count-3) {
//                    [weakSelf.table scrollToRowAtIndexPath:weakIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                }
                m.content = text;
            }];
            return cell;
        }
    }
    return nil;
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.allowsSelection = NO;
        _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        [_table registerClass:[ZXFInputFieldCell class] forCellReuseIdentifier:NSStringFromClass([ZXFInputFieldCell class])];
        [_table registerClass:[ZXFInputImageCell class] forCellReuseIdentifier:NSStringFromClass([ZXFInputImageCell class])];
        [_table registerClass:[ZXFInputViewCell class] forCellReuseIdentifier:NSStringFromClass([ZXFInputViewCell class])];
    }
    return _table;
}

- (UIButton *)createStudioButton
{
    if (!_createStudioButton) {
        _createStudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createStudioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createStudioButton setTitle:@"创建" forState:UIControlStateNormal];
        _createStudioButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _createStudioButton;
}

- (CreateWordStudioPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[CreateWordStudioPageModel alloc] init];
        
    }
    return _pageModel;
}

@end
