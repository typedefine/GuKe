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
    
    [self getData];
}

- (void)getData
{
    NSString *urlString = DEBUG ? @"http://113.31.119.175/bones/app/msg/msg_list.json" : [NSString stringWithFormat:@"%@%@",requestUrl,patient_msg_list];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:@{@"sessionid":sessionIding} success:^(id data) {
        NSLog(@"患者留言--留言信息%@",data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            [self.pageModel configureWithData:dict[@"data"]];
        }
        [self hideHud];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"患者留言--留言信息error:%@",error);
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pageModel.cellModelList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientMessageCell class])];
    PatientMessageCellModel *cellModel = _pageModel.cellModelList[indexPath.row];
    [cell configureCellWithData:cellModel reply:^(id  _Nonnull model) {
        
    }];
    return cell;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[PatientMessageCell class] forCellReuseIdentifier:NSStringFromClass([PatientMessageCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (PatientMessagePageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[PatientMessagePageModel alloc] init];
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
