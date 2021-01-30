//
//  CreateGroupController.m
//  GuKe
//
//  Created by yb on 2021/1/2.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "CreateWorkGroupController.h"
#import "ZXFInputFieldCell.h"
#import "ZXFInputImageCell.h"
#import "ZXFInputViewCell.h"
#import "CreateGroupPageModel.h"

@interface CreateWorkGroupController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CreateGroupPageModel *pageModel;
@property (nonatomic, strong) UIButton *createStudioButton;
@end

@implementation CreateWorkGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
}

- (void)addSubViews
{
    self.title = @"创建群组";
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
    NSString *name = self.pageModel.cellModelList[0].content;
    if (!name.isValidStringValue) {
        [self showHint:@"请输入工作组名称"];
        return;
    }
    
    NSString *logoUrl = self.pageModel.cellModelList[1].content;
    if (!logoUrl.isValidStringValue) {
        [self showHint:@"请输入工作组logo" inView:self.view];
        return;
    }
    
    NSString *desc = self.pageModel.cellModelList[2].content;
    if (!desc.isValidStringValue) {
        [self showHint:@"请输入工作组介绍" inView:self.view];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,urlpath_create_workgroup];
    NSMutableDictionary *para = [@{
//        @"sessionId":sessionIding,
        @"groupname":name,
        @"groupportrait":logoUrl,
        @"desc":desc,
        @"groupType":self.superGroupId
    } mutableCopy];
   
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        NSLog(@"创建工作组-->%@",data);
        [self hideHud];
        if ([data[@"retcode"] isEqualToString:@"0000"]) {
            self.createStudioButton.enabled = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self popBack];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self showHint:data[@"message"] inView:self.view];
        }
    } failure:^(NSError *error) {
        NSLog(@"创建工作组-->%@",error);
        [self hideHud];
        [self showHint:@"创建工作组失败" inView:self.view];
    }];
}

- (void)popBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
            [cell configureWithTitle:m.title placeholder:m.placeholder content:m.content input:^(NSString * _Nonnull text) {
//                [weakSelf.table scrollToRowAtIndexPath:weakIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                m.content = text;
            }];
            return cell;
        }
            
        default:
        {
            ZXFInputFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZXFInputFieldCell class])];
            [cell configWithTitle:m.title placeholder:m.placeholder content:m.content completion:^(NSString * _Nonnull text) {
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
        _createStudioButton.backgroundColor = greenC;
    }
    return _createStudioButton;
}

- (CreateGroupPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[CreateGroupPageModel alloc] init];
        
    }
    return _pageModel;
}

@end

