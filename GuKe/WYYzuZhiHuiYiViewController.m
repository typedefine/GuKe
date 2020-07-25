//
//  WYYzuZhiHuiYiViewController.m
//  GuKe
//
//  Created by yu on 2018/1/19.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYzuZhiHuiYiViewController.h"
#import "HuiyiTableViewCell.h"
#import "WoDeHuiYiTableViewCell.h"
#import "FaBuHuiYiViewController.h"
#import "HuiYiXiangQingViewController.h"
#import "ZJNSignUpMeetingViewController.h"
#import "UIViewController+BackButtonHandler.h"
@interface WYYzuZhiHuiYiViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *wodeTable;
    
    NSMutableArray *zuzhiArr;
    NSDate * comeDate;//进入模块的时间

}
@property (nonatomic,strong)UIButton *issueButton;//有上角按钮

@end

@implementation WYYzuZhiHuiYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我组织的会议";
    comeDate =[NSDate date];

    // 1.把返回文字的标题设置为空字符串(A和B都是UIViewController)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.issueButton.frame = CGRectMake(0, 0, 54, 30);
    self.issueButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [_issueButton setTitle:@"添加" forState:UIControlStateNormal];
    _issueButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_issueButton addTarget:self action:@selector(onClickedOKNeedView) forControlEvents:UIControlEventTouchUpInside];
    
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:_issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didShuaXinHuiYiList) name:@"refreshHuiYiList" object:nil];
    zuzhiArr = [NSMutableArray array];
    
    [self makeAddTableview];
    
    [self makeHuiYiZuZhi];
    
    // Do any additional setup after loading the view.
}
//返回按钮点击实现方法
-(void)backButtonClick{
    [moduleDate ShareModuleDate].MymeetingLength =[[NSDate date]timeIntervalSinceDate:comeDate];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)onClickedOKNeedView{
    FaBuHuiYiViewController *fa = [[FaBuHuiYiViewController alloc]init];
    fa.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fa animated:NO];
}
- (void)didShuaXinHuiYiList{
    [zuzhiArr removeAllObjects];
    [self makeHuiYiZuZhi];
}
#pragma  mark 我组织的会议
- (void)makeHuiYiZuZhi{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,meetingorganization];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我组织的会议%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [zuzhiArr addObjectsFromArray:data[@"data"]];
        }
        [self hideHud];
        [wodeTable reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我组织的会议%@",error);
    }];
}
- (void)makeAddTableview{
    wodeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 64) style:UITableViewStyleGrouped];
    wodeTable.delegate = self;
    wodeTable.dataSource = self;
    wodeTable.separatorStyle = UITableViewCellAccessoryNone;
    wodeTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:wodeTable];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return zuzhiArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *infoDic = zuzhiArr[indexPath.section];
    NSString *titleStr = infoDic[@"meetingName"];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    CGFloat height = [titleStr boundingRectWithSize:CGSizeMake(ScreenWidth-105, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    return 85+(height-20);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdte = @"cellIdter";
    WoDeHuiYiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdte];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WoDeHuiYiTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *infoDic = zuzhiArr[indexPath.section];
    NSString *status = [NSString stringWithFormat:@"%@",infoDic[@"status"]];
    if ([status isEqualToString:@"0"]) {
        cell.nameImageView.hidden = YES;
        cell.timeImageView.hidden = YES;
        cell.img.image = [UIImage imageNamed:@"default_img"];
        cell.titlelAB.text =@"抱歉，您的内容因未通过审核已被删除。";
    }else{
        [cell.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,zuzhiArr[indexPath.section][@"image"]]] placeholderImage:[UIImage imageNamed:@"我组织的会议-img2"]];
        cell.img.clipsToBounds = YES;
        cell.img.contentMode  = UIViewContentModeScaleAspectFill;
        cell.titlelAB.text = [NSString stringWithFormat:@"%@",infoDic[@"meetingName"]];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",infoDic[@"speakerUser"]];
        cell.timeLab.text = [NSString stringWithFormat:@"%@",infoDic[@"beginTime"]];
    }
    
    UILongPressGestureRecognizer *longGeture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPress:)];
    [cell addGestureRecognizer:longGeture];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HuiYiXiangQingViewController *xiang = [[HuiYiXiangQingViewController alloc]init];
    xiang.huiyiid = zuzhiArr[indexPath.section][@"uid"];
    xiang.titleStr = zuzhiArr[indexPath.section][@"meetingName"];
    xiang.iconImagePatn = zuzhiArr[indexPath.section][@"image"];
    xiang.content =zuzhiArr[indexPath.section][@"content"];
    xiang.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xiang animated:NO];
}
#pragma mark 删除我发布的会议
- (void)didLongPress:(UILongPressGestureRecognizer *)senderlong{
    CGPoint locations = [senderlong locationInView:wodeTable];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除这条会议吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *indexPath = [wodeTable indexPathForRowAtPoint:locations];
        NSString *huiyiID = [NSString stringWithFormat:@"%@",zuzhiArr[indexPath.row][@"uid"]];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/app/meeting/delete.json",requestUrl];
        NSArray *keysArray = @[@"sessionid",@"uid"];
        NSArray *valueArray = @[sessionIding,huiyiID];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            NSLog(@"删除我发布的会议%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                
                [zuzhiArr removeObjectAtIndex:indexPath.row];
                [wodeTable reloadData];
            }
            [self showHint:data[@"message"]];
            [self hideHud];
            
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"删除我发布的会议%@",error);
        }];
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:sureAction];
    
    if([ZJNDeviceInfo deviceIsPhone]){
        
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else{
        
        UIPopoverPresentationController *popPresenter = [alertC
                                                         popoverPresentationController];
        popPresenter.sourceView = self.view; // 这就是挂靠的对象
        popPresenter.sourceRect = self.view.bounds;
        [self presentViewController:alertC animated:YES completion:nil];
    }
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
