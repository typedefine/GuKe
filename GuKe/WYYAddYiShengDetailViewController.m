//
//  WYYAddYiShengDetailViewController.m
//  GuKe
//
//  Created by yu on 2018/1/18.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYAddYiShengDetailViewController.h"
#import "WYYQunLiaoOneTableViewCell.h"
#import "WYYYiShengOneTableViewCell.h"
#import "WYYYiShengTwoTableViewCell.h"
@interface WYYAddYiShengDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    UITableView *detailTableview;
    NSArray *titleaRR;
    NSDictionary *detailDic;
    NSArray *detailArr;//存放姓名，医院，科室，职称的数组
    CGRect heightRect;
    NSArray *zhuanchangArr;//存放个人专长

}

@end

@implementation WYYAddYiShengDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生详情";
    self.view.backgroundColor = [UIColor whiteColor];
    titleaRR = @[@"姓名",@"医院",@"科室",@"职称"];
    [self makeAddTableview];
    [self makeData];
    
    // Do any additional setup after loading the view.
}
#pragma mark  医生详情
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfriendlookdoctor];
    NSArray *keysArray = @[@"sessionId",@"userid"];
    NSArray *valueArray = @[sessionIding,self.userID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSLog(@"医生详情%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            detailDic = [[NSDictionary alloc]initWithDictionary:data[@"data"]];
            detailArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"doctorName"]],[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"hosptialName"]],[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"deptName"]],[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"titleName"]], nil];
            zhuanchangArr = [NSArray arrayWithArray:data[@"data"][@"specialty"]];
            [detailTableview reloadData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"医生详情%@",error);
    }];
}
- (void)makeAddTableview{
    if (IS_IPGONE_X) {
        detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 86)style:UITableViewStyleGrouped];
    }else{
        detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStyleGrouped];
    }
    detailTableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:detailTableview];
    detailTableview.delegate = self;
    detailTableview.dataSource = self;
    detailTableview.tableFooterView = [[UIView alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 6;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            return 44 + heightRect.size.height;
        }
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            static NSString *cellIdone = @"cellIdone";
            WYYYiShengOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYYiShengOneTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            CGFloat  whitess = 0 ;
            CGFloat  spaceBtn = 20;
            CGFloat  whiteS = 0;
            for (int a = 0; a < zhuanchangArr.count; a ++ ) {
                UILabel *labesl = [[UILabel alloc]init];
                labesl.text = [NSString stringWithFormat:@"%@",zhuanchangArr[a][@"specialtyId"]];
                labesl.font = [UIFont systemFontOfSize:12];
                labesl.textAlignment = NSTextAlignmentCenter;
                labesl.textColor = greenC;
                labesl.layer.masksToBounds = YES;
                labesl.layer.cornerRadius = 2;
                labesl.layer.borderWidth = 1;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.02, 0.64, 0.48, 1 });
                [labesl.layer setBorderColor:colorref];//边框颜色



                whitess += (whiteS + spaceBtn) ;

                CGRect whiteRect = [labesl boundingRectWithInitSize:labesl.frame.size];
                whiteS = whiteRect.size.width + 5;

                labesl.frame = CGRectMake(whitess, 0, whiteS + 5, 20);
                [cellOne.scrollview addSubview:labesl];


            }
            cellOne.scrollview.contentSize = CGSizeMake(whitess + whiteS, 0);
            
            cellOne.titleLab.text = @"专长";
            cellOne.scrollview.hidden = NO;
            cellOne.imgView.hidden = YES;
            return cellOne;
        }else if (indexPath.row == 5){
            static NSString *cellIdone = @"cellIdone";
            WYYYiShengTwoTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYYiShengTwoTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cellOne.imageView.hidden = YES;
            cellOne.personInfo.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"content"]];
            cellOne.personInfo.numberOfLines = 0;
            heightRect = [cellOne.personInfo boundingRectWithInitSize:cellOne.personInfo.frame.size];
            cellOne.personInfo.frame = CGRectMake(16, 34, ScreenWidth - 30, heightRect.size.height);
            
            return cellOne;
        }else{
            static NSString *cellIdone = @"cellIdone";
            WYYQunLiaoOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYQunLiaoOneTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cellOne.titleLab.text = titleaRR[indexPath.row];
            cellOne.swBtn.hidden = YES;
            cellOne.detailLab.text = detailArr[indexPath.row];
            return cellOne;
        }
    }else{
        static NSString *cellIdone = @"cellIdone";
        WYYYiShengOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
        if (!cellOne) {
            cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYYiShengOneTableViewCell" owner:self options:nil] lastObject];
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cellOne.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[detailDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
        return cellOne;
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
