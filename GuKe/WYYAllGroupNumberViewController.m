//
//  WYYAllGroupNumberViewController.m
//  GuKe
//
//  Created by yu on 2018/1/25.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYAllGroupNumberViewController.h"
#import "WYYMainGroupTableViewCell.h"
@interface WYYAllGroupNumberViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *groupTableview;
}

@end

@implementation WYYAllGroupNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群成员";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeAddTableview];
    // Do any additional setup after loading the view.
}
#pragma mark add tableview
- (void)makeAddTableview{
    groupTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:groupTableview];
    groupTableview.delegate = self;
    groupTableview.dataSource = self;
    groupTableview.tableFooterView = [[UIView alloc]init];
}
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArr.count;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    WYYMainGroupTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WYYMainGroupTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cellTwo.GroupImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,self.groupArr[indexPath.row][@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
    cellTwo.GroupNameLab.text = [NSString stringWithFormat:@"%@",self.groupArr[indexPath.row][@"name"]];
    return cellTwo;
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
