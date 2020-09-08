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
//#import "ZJNChangePatientBasicInfoViewController.h"
#import "ReplyPatientBookTimePopover.h"
#import "ShuHouSUFangViewController.h"

@interface PatientBookController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PatientBookPageModel *pageModel;
@property (nonatomic, strong) ReplyPatientBookTimePopover *replyPopover;

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
    __block PatientBookCellModel *cellModel = self.pageModel.cellModelList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell configureCellWithData:cellModel reply:^(PatientMessageModel *model) {
        [weakSelf.replyPopover showWithData:model reply:^(PatientMessageModel * _Nonnull model, NSDate * _Nonnull date) {
            [weakSelf replyWithData:cellModel date:date];
        }];
    }];
    return cell;
}

- (void)replyWithData:(PatientBookCellModel *)cellModel date:(NSDate *)date
{
    NSString *time = @(ceil([date timeIntervalSince1970])).stringValue;
    NSDictionary *para = @{
        @"sessionid":self.pageModel.sessionId,
        @"recipient": cellModel.model.sender,
        @"content": @"预约回复",
        @"medicalTime": time
    };
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:self.pageModel.replyUrl parameters:para success:^(id data) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@%@",self.pageModel.replyPrint, data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            cellModel.model.medicalTime = time;
            [cellModel updateMedicalTime:time];
//            [self.pageModel configureWithData:dict[@"data"]];
        }
        [self hideHud];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@error:%@", self.pageModel.replyPrint, error);
    }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientBookCellModel *cellModel = self.pageModel.cellModelList[indexPath.row];
    
    NSString *strings = cellModel.model.hospnumId;
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    [defau setObject:strings forKey:@"hospitalnumbar"];
    [defau synchronize];
    
    ShuHouSUFangViewController *shuhuo = [[ShuHouSUFangViewController alloc]init];
    shuhuo.numbers = 0;
    shuhuo.infoDic = @{@"shares":@"0"};
    shuhuo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shuhuo animated:NO];
    
    
    /*
    ZJNChangePatientBasicInfoViewController *pvc = [[ZJNChangePatientBasicInfoViewController alloc] init];
    pvc.hidesBottomBarWhenPushed = YES;
    pvc.isfromPatientMsg = YES;
    ZJNChangePatientBasicInfoModel *model = [[ZJNChangePatientBasicInfoModel alloc]init];
    model.sessionId = self.pageModel.sessionId;
    model.hospnumId = cellModel.model.hospnumId;
    pvc.infoModel = model;
    pvc.refershPatientInfo = ^{
    };
    [self.navigationController pushViewController:pvc animated:YES];
    */
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
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_book];
        msg = @"患者留言--预约就诊";
        _pageModel.loadUrl = urlString;
        _pageModel.msgPrint = msg;
        
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_book_replied];
        msg = @"患者留言--回复预览就诊";
        _pageModel.replyUrl = urlString;
        _pageModel.replyPrint = msg;
        
        _pageModel.sessionId = sessionIding;
    }
    return _pageModel;
}

- (ReplyPatientBookTimePopover *)replyPopover
{
    if (!_replyPopover) {
        _replyPopover = [[ReplyPatientBookTimePopover alloc] init];
    }
    return _replyPopover;
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
