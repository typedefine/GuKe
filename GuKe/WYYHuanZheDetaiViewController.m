//
//  WYYHuanZheDetaiViewController.m
//  GuKe
//
//  Created by yu on 2018/1/18.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYHuanZheDetaiViewController.h"
#import "WYYDetailOneTableViewCell.h"
@interface WYYHuanZheDetaiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *detailTableview;
    NSDictionary *huanDetailDic;//患者详情
}

@end

@implementation WYYHuanZheDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeData];
    [self addTableview];
    
    // Do any additional setup after loading the view.
}
#pragma mark  患者详情
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfriendlookpatient];
    NSArray *keysArray = @[@"sessionId",@"userid"];
    NSArray *valueArray = @[sessionIding,self.userID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"患者详情%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            huanDetailDic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
        }else{
            [self showHint:data[@"message"]];
        }
        [detailTableview reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"患者详情%@",error);
    }];
}
#pragma mark add tableview
- (void)addTableview{
    detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    detailTableview.delegate = self;
    detailTableview.dataSource = self;
    detailTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:detailTableview];
}
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdone = @"cellIdone";
    WYYDetailOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
    if (!cellOne) {
        cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYDetailOneTableViewCell" owner:self options:nil] lastObject];
        cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cellOne.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[huanDetailDic objectForKey:@"userPortrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
    cellOne.oneLab.text = [NSString stringWithFormat:@"%@",[huanDetailDic objectForKey:@"userName"]];
    NSString *sexsTR = [NSString stringWithFormat:@"%@",[huanDetailDic objectForKey:@"userGender"]];
    if ([sexsTR isEqualToString:@"1"]) {
        cellOne.twoLab.text = [NSString stringWithFormat:@"男   %@岁   %@",[huanDetailDic objectForKey:@"age"],[huanDetailDic objectForKey:@"userNation"]];
    }else{
        cellOne.twoLab.text = [NSString stringWithFormat:@"女   %@岁   %@",[huanDetailDic objectForKey:@"age"],[huanDetailDic objectForKey:@"userNation"]];
    }
    
    cellOne.threeLab.text = [NSString stringWithFormat:@"家庭住址:%@",[huanDetailDic objectForKey:@"userHomeadress"]];
    return cellOne;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
