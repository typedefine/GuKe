//
//  MainHuiYiViewController.m
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MainHuiYiViewController.h"
#import "HuiyiTableViewCell.h"
#import "WoDeHuiYiTableViewCell.h"
#import "FaBuHuiYiViewController.h"
#import "HuiYiXiangQingViewController.h"
#import "ZJNSignUpMeetingViewController.h"
@interface MainHuiYiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *huiyiTable;
    UITableView *wodeTable;
    NSMutableArray *baomingArr;
    
}
@property (nonatomic,strong)UIButton *selectbtns;

@end

@implementation MainHuiYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的会议";
    self.view.backgroundColor = [UIColor whiteColor];
    baomingArr = [NSMutableArray array];
    [self makeAddTableview];
    [self makeHuiYiBaoming];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)onClickedOKNeedView{
    FaBuHuiYiViewController *fa = [[FaBuHuiYiViewController alloc]init];
    fa.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fa animated:NO];
}


#pragma mark 我报名的会议
- (void)makeHuiYiBaoming{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,meetingmymeet];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我报名的会议%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [baomingArr addObjectsFromArray:data[@"data"]];
        }
        [huiyiTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"我报名的会议%@",error);
    }];

}
- (void)makeAddTableview{
    huiyiTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 64 ) style:UITableViewStyleGrouped];
    huiyiTable.delegate = self;
    huiyiTable.dataSource = self;
    huiyiTable.separatorStyle = UITableViewCellAccessoryNone;
    huiyiTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:huiyiTable];

}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return baomingArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90+ScreenWidth*(3/5.0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    HuiyiTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"HuiyiTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cellTwo.img.clipsToBounds = YES;
    cellTwo.img.contentMode  = UIViewContentModeScaleAspectFill;
    [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,baomingArr[indexPath.section][@"image"]]] placeholderImage:[UIImage imageNamed:@"我组织的会议-img2"]];
    cellTwo.titleLab.text = [NSString stringWithFormat:@"%@",baomingArr[indexPath.section][@"meetingName"]];
    cellTwo.namelAB.text = [NSString stringWithFormat:@"%@",baomingArr[indexPath.section][@"createUser"]];
    cellTwo.TimeLab.text = [NSString stringWithFormat:@"%@",baomingArr[indexPath.section][@"beginTime"]];
    cellTwo.addressLab.text = [NSString stringWithFormat:@"%@",baomingArr[indexPath.section][@"site"]];
    NSString *liveStr = [NSString stringWithFormat:@"%@",baomingArr[indexPath.section][@"live"]];
    if ([liveStr isEqualToString:@"1"]) {
        cellTwo.liveImageView.image = [UIImage imageNamed:@"直播中"];
    }else if ([liveStr isEqualToString:@"2"]){
        cellTwo.liveImageView.image = [UIImage imageNamed:@"回放"];
    }else{
        
    }
    return cellTwo;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJNSignUpMeetingViewController *viewC = [[ZJNSignUpMeetingViewController alloc]init];
    viewC.status = @"1";
    viewC.live = baomingArr[indexPath.section][@"live"];
    viewC.huiyiID = baomingArr[indexPath.section][@"uid"];
    viewC.shareImagePath = baomingArr[indexPath.section][@"image"];
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:NO];
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
