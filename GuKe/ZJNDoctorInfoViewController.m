//
//  ZJNDoctorInfoViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/12.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNDoctorInfoViewController.h"
#import "PersonalCenterTableViewCell.h"
@interface ZJNDoctorInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation ZJNDoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets=NO;
        // Fallback on earlier versions
    }
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (ScreenHeight>736) {
            if ([ZJNDeviceInfo deviceIsPhone]) {
                return 180;
            }
            return 150;
        }else{
            return 150;
        }
        
    }else if (indexPath.section == 1){
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];

        NSString *contentStr = [NSString changeNullString:self.infoDic[@"content"]];
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height + 20;
        return MAX(45, height);
    }else{
        NSString *contentStr;
        NSArray *array = self.infoDic[@"specialty"];
        if (array.count == 0) {
            return 45;
        }else{
            NSMutableArray *strArr = [NSMutableArray array];
            for (int i = 0; i <array.count; i ++) {
                NSDictionary *dic = array[i];
                [strArr addObject:dic[@"specialtyName"]];
            }
            contentStr = [strArr componentsJoinedByString:@","];
        }
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
        
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height + 20;
        return MAX(45, height);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
    greenImg.image = [UIImage imageNamed:@"矩形-6"];
    [heardView addSubview:greenImg];
    
    UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 0, 120, 44)];
    titlLab.font = Font14;
    titlLab.textColor = SetColor(0x1a1a1a);
    [heardView addSubview:titlLab];
    if (section == 0) {
        return nil;
    }else if (section == 1) {
        titlLab.text = @"医生简介";
    }else{
        titlLab.text = @"擅长领域";
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellid = @"cellid";
        PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterTableViewCell" owner:self options:nil]lastObject];
            
        }
        
        UITabBarItem *meItem = [self.tabBarController.tabBar.items objectAtIndex:3];
        if ([meItem.badgeValue integerValue]>0) {
            [cell.letterButton setImage:[UIImage imageNamed:@"红点信封"] forState:UIControlStateNormal];
        }
        cell.letterButton.hidden = YES;
        cell.arrowButton.hidden = YES;
        cell.model = [UserInfoModel yy_modelWithDictionary:self.infoDic];
        [cell.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString*cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        
        cell.textLabel.textColor = SetColor(0x333333);
        cell.textLabel.font = Font14;
        cell.textLabel.numberOfLines = 0;
        if (indexPath.section == 1) {
            cell.textLabel.text = [NSString changeNullString:self.infoDic[@"content"]];
        }else{
            NSString *contentStr;
            NSArray *array = self.infoDic[@"specialty"];
            if (array.count == 0) {
                contentStr = @"";
            }else{
                NSMutableArray *strArr = [NSMutableArray array];
                for (int i = 0; i <array.count; i ++) {
                    NSDictionary *dic = array[i];
                    [strArr addObject:dic[@"specialtyName"]];
                }
                contentStr = [strArr componentsJoinedByString:@","];
            }
            cell.textLabel.text = contentStr;
        }
        return cell;
    }
    
}
#pragma mark--返回按钮点击实现方法
-(void)backButtonClick:(UIButton *)button{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
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
