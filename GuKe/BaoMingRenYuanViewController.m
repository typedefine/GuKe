//
//  BaoMingRenYuanViewController.m
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "BaoMingRenYuanViewController.h"
#import "BaoMingRenYuanTableViewCell.h"
@interface BaoMingRenYuanViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *baomingtable;
}

@end

@implementation BaoMingRenYuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注人员";
    [self makeAddTableview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark add tableview
- (void)makeAddTableview{
    baomingtable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    baomingtable.delegate = self;
    baomingtable.dataSource = self;
    baomingtable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:baomingtable];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.docArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    BaoMingRenYuanTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"BaoMingRenYuanTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cellTwo.img.layer.masksToBounds = YES;
    cellTwo.img.layer.cornerRadius = 20;
    cellTwo.img.clipsToBounds = YES;
    cellTwo.img.contentMode = UIViewContentModeScaleAspectFill;
    
    [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,self.docArr[indexPath.row][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"个人头像-未认证"]];
    
    cellTwo.nameLab.text = [NSString stringWithFormat:@"%@",self.docArr[indexPath.row][@"doctorName"]];
    cellTwo.addressLab.text = [NSString stringWithFormat:@"%@",self.docArr[indexPath.row][@"hosptialName"]];
    
    return cellTwo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    YishengLiebiaoViewController *yi = [[YishengLiebiaoViewController alloc]init];
//    yi.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:yi animated:NO];
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
