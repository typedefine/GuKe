//
//  PatientBookController.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientBookController.h"
#import "PatientBookCell.h"
#import "PatientBookPageModel.h"

@interface PatientBookController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PatientBookPageModel *pageModel;

@end

@implementation PatientBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    [self getData];
}

- (void)getData
{
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:self.pageModel.loadUrl parameters:@{@"sessionid":self.pageModel.sessionId} success:^(id data) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@%@",self.pageModel.msgPrint, data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            [self.pageModel configureWithData:dict[@"data"]];
        }
        [self hideHud];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@error:%@", self.pageModel.msgPrint, error);
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pageModel.cellModelList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientBookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientBookCell class])];
    PatientBookCellModel *cellModel = self.pageModel.cellModelList[indexPath.row];
    [cell configureCellWithData:cellModel reply:^(PatientMessageModel *model) {
        
    }];
    return cell;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[PatientBookCell class] forCellReuseIdentifier:NSStringFromClass([PatientBookCell class])];
        _tableView.rowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (PatientBookPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[PatientBookPageModel alloc] init];
        NSString *urlString, *msg;
        urlString = DEBUG ? @"http://113.31.119.175/bones/app/msg/msg_book.json" : [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_book];
        msg = @"患者留言--预约就诊";
        _pageModel.loadUrl = urlString;
        _pageModel.msgPrint = msg;
        _pageModel.sessionId = sessionIding;
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
