//
//  PatientMessageController.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/19.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMessageController.h"
#import "PatientMessageCell.h"
#import "PatientMessagePageModel.h"
#import "PatientMsgChatController.h"


@interface PatientMessageController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PatientMessagePageModel *pageModel;

@end

@implementation PatientMessageController

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
    PatientMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientMessageCell class])];
    PatientMessageCellModel *cellModel = self.pageModel.cellModelList[indexPath.row];
    [cell configureCellWithData:cellModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientMessageCellModel *cellModel = self.pageModel.cellModelList[indexPath.row];
    PatientMsgChatController *msgChatVC = [[PatientMsgChatController alloc] init];
    msgChatVC.sessionid = self.pageModel.sessionId;
    msgChatVC.recipient = cellModel.model.sender;
    msgChatVC.nickname = cellModel.model.realName;
    msgChatVC.hospnumId = cellModel.model.hospnumId;
    msgChatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msgChatVC animated:YES];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[PatientMessageCell class] forCellReuseIdentifier:NSStringFromClass([PatientMessageCell class])];
        _tableView.rowHeight = 80;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (PatientMessagePageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[PatientMessagePageModel alloc] init];
        NSString *urlString, *msg;
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_list];
        msg = @"患者留言--留言信息";
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
