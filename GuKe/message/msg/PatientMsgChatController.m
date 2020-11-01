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
#import "MsgChatInputBar.h"
#import "PatientMsgChatPageModel.h"
//#import "ZJNChangePatientBasicInfoViewController.h"
#import "ShuHouSUFangViewController.h"

@interface PatientMsgChatController ()<UITableViewDelegate, UITableViewDataSource, MsgChatInputBarDelegate>

@property (nonatomic, strong) UIButton *naviRightButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MsgChatInputBar *bottomBar;
@property (nonatomic, strong) PatientMsgChatPageModel *pageModel;

@end

@implementation PatientMsgChatController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.nickname;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    [self getData];
    
    [self.view addSubview:self.bottomBar];
//    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
////        make.width.mas_equalTo(ScreenWidth);
//        make.height.mas_equalTo(49);
//    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)showKeyboard:(NSNotification *)notification
{
    [self scrollToBottom];
}

- (void)dismissKeyboard:(NSNotification *)notification
{

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    __weak typeof(self) weakSelf = self;
    if (cellModel.isPatient) {
        PatientChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientChatCell class])];
        [cell configureCellWithData:cellModel action:^{
            [weakSelf patientInfoPage];
        }];
        return cell;
    }else{
        DoctorChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DoctorChatCell class])];
        [cell configureCellWithData:cellModel action:^{
            [weakSelf sendMsg:@"填写就诊信息" type:2];
        }];
        
        return cell;
    }
    
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TabbarHeight)];
        [_tableView registerClass:[PatientChatCell class] forCellReuseIdentifier:NSStringFromClass([PatientChatCell class])];
        [_tableView registerClass:[DoctorChatCell class] forCellReuseIdentifier:NSStringFromClass([DoctorChatCell class])];
//        _tableView.rowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)naviRightButton
{
    if (!_naviRightButton) {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (@available(iOS 13.0, *)) {
            [_naviRightButton setImage:[[UIImage imageNamed:@"icon4_1"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
            [_naviRightButton setImage:[UIImage imageNamed:@"icon4_1"] forState:UIControlStateNormal];
        }
        [_naviRightButton addTarget:self action:@selector(patientInfoPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviRightButton;
}

- (void)patientInfoPage
{
    
    NSString *strings = self.pageModel.hospnumId;
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    [defau setObject:strings forKey:@"hospitalnumbar"];
    [defau synchronize];
    
    ShuHouSUFangViewController *shuhuo = [[ShuHouSUFangViewController alloc]init];
    shuhuo.numbers = 0;
    shuhuo.infoDic = @{@"shares":@"0"};
//    shuhuo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shuhuo animated:NO];
    /*
    ZJNChangePatientBasicInfoViewController *pvc = [[ZJNChangePatientBasicInfoViewController alloc] init];
    pvc.isfromPatientMsg = YES;
    ZJNChangePatientBasicInfoModel *model = [[ZJNChangePatientBasicInfoModel alloc]init];
    model.sessionId = self.pageModel.sessionId;
    model.hospnumId = self.pageModel.hospnumId;
    pvc.infoModel = model;
    pvc.refershPatientInfo = ^{
    };
    
    [self.navigationController pushViewController:pvc animated:YES];
     */
}

- (MsgChatInputBar *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[MsgChatInputBar alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavBarHeight - TabbarHeight, ScreenWidth, TabbarHeight)];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}

- (void)inputBarChanged:(MsgChatInputBar *)inputBar
{
    
}

- (void)inputBarSendAction:(MsgChatInputBar *)inputBar
{
    [self sendMsg:inputBar.text type:0];
}


- (PatientMsgChatPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[PatientMsgChatPageModel alloc] init];
        NSString *urlString, *msg;
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_record];
        msg = @"患者留言--留言详情";
        _pageModel.loadUrl = urlString;
        _pageModel.msgPrint = msg;
        
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_send];
        _pageModel.sendUrl = urlString;
        msg = @"患者留言--发送消息";
        _pageModel.sendPrint = msg;
        
        _pageModel.sessionId = self.sessionid;
        _pageModel.recipient = self.recipient;
        _pageModel.hospnumId = self.hospnumId;
    }
    return _pageModel;
}


-(BOOL)navigationShouldPopOnBackButton
{
    return  YES ;
}

- (void)sendMsg:(NSString *)text type:(NSInteger)type
{
    [self showHudInView:self.view hint:nil];
    NSDictionary *para = @{@"sessionid":self.pageModel.sessionId, @"recipient":self.recipient, @"content":text, @"type":@(type)};
    [ZJNRequestManager postWithUrlString:self.pageModel.sendUrl parameters:para success:^(id data) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@%@",self.pageModel.sendPrint, data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            [self.pageModel addData:dict[@"data"]];
        }
        [self hideHud];
        [self.tableView reloadData];
        [self scrollToBottom];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@error:%@", self.pageModel.sendPrint, error);
    }];
}


- (void)scrollToBottom
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.pageModel.cellModelList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
