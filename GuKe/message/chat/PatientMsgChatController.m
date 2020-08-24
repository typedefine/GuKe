//
//  PatientBookController.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/19.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMsgChatController.h"
#import "PatientChatCell.h"
#import "DoctorChatCell.h"
#import "PatientMsgChatPageModel.h"

@interface PatientMsgChatController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PatientMsgChatPageModel *pageModel;

@end

@implementation PatientMsgChatController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.tabBarController.tabBar.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.tabBarController.tabBar.hidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.nickname;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    [self getData];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)getData
{
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager getWithUrlString:self.pageModel.loadUrl parameters:@{@"sessionid":self.pageModel.sessionId, @"recipient":self.recipient, @"page":@(1)} success:^(id data) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.pageModel.cellModelList[indexPath.row].height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    PatientMsgChatCellModel *cellModel = self.pageModel.cellModelList[indexPath.row];
    if (cellModel.isPatient) {
        PatientChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientChatCell class])];
        [cell configureCellWithData:cellModel];
        return cell;
    }else{
        DoctorChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DoctorChatCell class])];
        [cell configureCellWithData:cellModel];
        return cell;
    }
    
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[PatientChatCell class] forCellReuseIdentifier:NSStringFromClass([PatientChatCell class])];
        [_tableView registerClass:[DoctorChatCell class] forCellReuseIdentifier:NSStringFromClass([DoctorChatCell class])];
//        _tableView.rowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (PatientMsgChatPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[PatientMsgChatPageModel alloc] init];
        NSString *urlString, *msg;
        urlString = DEBUG ? @"http://113.31.119.175/bones/app/msg/msg_record.json" : [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_record];
        msg = @"患者留言--留言详情";
        _pageModel.loadUrl = urlString;
        _pageModel.msgPrint = msg;
        _pageModel.sessionId = self.sessionid;
        _pageModel.recipient = self.recipient;
    }
    return _pageModel;
}


-(BOOL)navigationShouldPopOnBackButton{

    return  YES ;
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
