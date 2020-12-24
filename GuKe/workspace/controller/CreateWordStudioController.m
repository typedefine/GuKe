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
    self.title = @"申请开通工作室";
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
    return self.pageModel.cellModelList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.pageModel.cellModelList[indexPath.row].height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXFInputCellModel *m = self.pageModel.cellModelList[indexPath.row];
    __weak typeof(self) weakSelf = self;
//    __weak NSIndexPath *weakIndexPath = indexPath;
    switch (m.cellType) {
        case ZXFInputCellTypeImagePick:
        {
            ZXFInputImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputImageCell class])];
            [cell configureWithTitle:m.title indicate:m.placeholder imgUrl:m.content completion:^(id  _Nonnull data) {
                            
            }];
            return cell;
        }
            break;
        
        case ZXFInputCellTypeTextView:
        {
            ZXFInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputViewCell class])];
            [cell configureWithTitle:m.title content:m.content input:^(NSString * _Nonnull text) {
//                [weakSelf.table scrollToRowAtIndexPath:weakIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }];
            return cell;
        }
            break;
            
        default:
        {
            ZXFInputFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputFieldCell class])];
            [cell configWithTitle:m.title placeholder:m.placeholder completion:^(NSString * _Nonnull text) {
//                if (weakIndexPath.row >= weakSelf.pageModel.cellModelList.count-3) {
//                    [weakSelf.table scrollToRowAtIndexPath:weakIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                }
            }];
            return cell;
        }
            break;
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

- (CreateWordStudioPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[CreateWordStudioPageModel alloc] init];
        
    }
    return _pageModel;
}

@end
