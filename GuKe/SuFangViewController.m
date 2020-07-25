//
//  SuFangViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SuFangViewController.h"
#import "SuiFangTableViewCell.h"
#import "DatePickerView.h"
#import "ShuHouSUFangViewController.h"
#import "AddFollow_UpRecordsViewController.h"
@interface SuFangViewController ()<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate>{
    UITableView *SuiTable;
    NSMutableArray *tixingArr;
    UIView * _backWindowView;
    NSString *timeStr;//时间
    NSString *tixingTime;//提醒时间
    NSString *callbackId;//回访id
    UIButton *btns;
    
    NSString *StringOne;
    
    NSArray *zuitimeArr;
    NSArray *tixingTimeArr;
    
    UITableView *timeTableview;
    
    UIView *heiseView;//黑色遮罩层
    UIView *tabbarView;//tabbar上面的遮罩层
}
@property(nonatomic,strong)DatePickerView * pikerView;
@end

@implementation SuFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的随访";
    tixingArr = [NSMutableArray array];

    tixingTime = @"30";
    self.view.backgroundColor = SetColor(0xf0f0f0);
    [self makeAddTableview];
    
    [self makeSuiFanglistTime];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [tixingArr removeAllObjects];
    [super viewWillAppear:animated];
    [self makeSuiFang];
}
#pragma mark  我的随访
- (void)makeSuiFang{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,callbacklist];
    NSArray *keysArray = @[@"sessionid",@"time"];
    NSArray *valueArray = @[sessionIding,tixingTime];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的随访%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [tixingArr addObjectsFromArray:data[@"data"]];
        }else{
            [self showHint:data[@"message"]];
        }
        [SuiTable reloadData];
        
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的随访%@",error);
    }];
}
#pragma mark 我的随访--随访时间
- (void)makeSuiFanglistTime{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,cyclelist];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的随访--随访时间%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            tixingTimeArr = [NSArray arrayWithArray:data[@"data"]];
        }
        [timeTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"我的随访--随访时间%@",error);
    }];
}
#pragma mark add view 
- (void)makeAddTableview{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *lat = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 20)];
    lat.textColor = SetColor(0x1a1a1a);
    lat.font = Font14;
    lat.text = [NSString stringWithFormat:@"随访时间"];
    [backView addSubview:lat];
    
    btns = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lat.frame) + 10, 0, 100, 40)];
    btns.titleLabel.font = [UIFont systemFontOfSize:14];
    [btns setTitleColor:SetColor(0x1a1a1a) forState:normal];
    [btns setTitle:@"一个月" forState:normal];
    [btns setImage:[UIImage imageNamed:@"三角-选择"] forState:normal];
    [btns setImage:[UIImage imageNamed:@"三角_当前"] forState:UIControlStateSelected];
    btns.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    btns.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [btns addTarget:self action:@selector(didTimesuifanghsijianButton) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:btns];

    SuiTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 64 - 50 - 49)];
    SuiTable.delegate = self;
    SuiTable.dataSource = self;
    SuiTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:SuiTable];
    
    if ([self.typeStr isEqualToString:@"1"]) {
        SuiTable.frame =CGRectMake(0, 50, ScreenWidth, ScreenHeight - 64 - 50);
    }else{
        SuiTable.frame =CGRectMake(0, 50, ScreenWidth, ScreenHeight - 64 - 50 - 49);
    }
    
    
    //heiseView
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0,50, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view  addSubview:heiseView];
    heiseView.hidden = YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    
    //tabbarView
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    tabbarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.tabBarController.tabBar addSubview:tabbarView];
    UITapGestureRecognizer*tapGestu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [tabbarView addGestureRecognizer:tapGestu];
    tabbarView.hidden = YES;

    
    timeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 176) style:UITableViewStylePlain];
    timeTableview.delegate = self;
    timeTableview.dataSource = self;
    timeTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:timeTableview];
    timeTableview.hidden = YES;
    
    
}

#pragma mark 黑色遮罩层点击事件
- (void)didViewBlockView{
    heiseView.hidden =YES;
    timeTableview.hidden = YES;
    tabbarView.hidden = YES;
}


- (void)didTimesuifanghsijianButton{
    tabbarView.hidden =! tabbarView.hidden;
    heiseView.hidden =! heiseView.hidden;
    timeTableview.hidden =! timeTableview.hidden;
    
}
#pragma mark 随访时间
- (void)didTimeButton{
    if(_pikerView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:_backWindowView];
        _pikerView = [DatePickerView datePickerView];
        _pikerView.delegate = self;
        _pikerView.type = 0;
        _pikerView.frame= CGRectMake(0, ScreenHeight, ScreenWidth, 184);
        [[UIApplication sharedApplication].keyWindow addSubview:_pikerView];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _pikerView.frame = CGRectMake(0, ScreenHeight-184, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
        } completion:^(BOOL finished) {
            [self.pikerView removeFromSuperview];
            self.pikerView = nil;
        }];
    }
}

- (void)getcancel{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.pikerView removeFromSuperview];
        self.pikerView = nil;
    }];

}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    timeStr = [NSString stringWithFormat:@"%@", date];
    
    NSLog(@"%@",timeStr);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
            [self.pikerView removeFromSuperview];
            self.pikerView = nil;
    }];
    
    [self makeTiJiao];
    
}
- (void)makeTiJiao{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,callbackupdate];
    NSArray *keysArray = @[@"sessionid",@"callbackId",@"time"];
    NSArray *valueArray = @[sessionIding,callbackId,timeStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"修改回访时间%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [tixingArr removeAllObjects];
            [self makeSuiFang];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"修改回访时间%@",error);
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == timeTableview) {
        return tixingTimeArr.count;
    }else{
        return tixingArr.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == timeTableview) {
        return 44;
    }else{
        return 110;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==SuiTable) {
        static NSString *cellIdter = @"cellId";
        SuiFangTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
        if (!cellTwo) {
            cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"SuiFangTableViewCell" owner:self options:nil] lastObject];
            cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellTwo.suiFangImg.hidden = YES;
        NSString *gender = [NSString changeNullString:tixingArr[indexPath.row][@"gender"]];
        if ([gender isEqualToString:@"0"]) {
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,tixingArr[indexPath.row][@"patientImage"]]] placeholderImage:[UIImage imageNamed:@"nv"]];
        }else if ([gender isEqualToString:@"1"]){
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,tixingArr[indexPath.row][@"patientImage"]]] placeholderImage:[UIImage imageNamed:@"nan"]];
        }else{
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,tixingArr[indexPath.row][@"patientImage"]]] placeholderImage:[UIImage imageNamed:@"个人头像-未认证"]];
        }
        
        cellTwo.nameLab.text = [NSString stringWithFormat:@"%@",tixingArr[indexPath.row][@"patientName"]];
        cellTwo.phoneLab.text = [NSString stringWithFormat:@"%@",tixingArr[indexPath.row][@"phone"]];
        cellTwo.zhangduanLab.text = [NSString stringWithFormat:@"诊断情况：%@",tixingArr[indexPath.row][@"diagnosis"]];
        cellTwo.timeLab.text = [NSString stringWithFormat:@"随访时间：%@",tixingArr[indexPath.row][@"callbackTime"]];
        cellTwo.shoushuTimeLab.text = [NSString stringWithFormat:@"手术时间：%@",tixingArr[indexPath.row][@"surgeryTime"]];
        cellTwo.timeBtn.tag = indexPath.row;
        [cellTwo.timeBtn addTarget:self action:@selector(didTimesuifangButton:) forControlEvents:UIControlEventTouchUpInside];
        cellTwo.zuifangBtn.tag = 100+indexPath.row;
        [cellTwo.zuifangBtn addTarget:self action:@selector(didSuiFangAddButton:) forControlEvents:UIControlEventTouchUpInside];
        return cellTwo;

    }else{
        static NSString *cellTwo = @"cellTwo";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 20, 16)];
        
        imageOne.image = [UIImage imageNamed:@"TICK"];
        [cell.contentView addSubview:imageOne];
        imageOne.tag = indexPath.row + 10;
        imageOne.hidden = YES;
        
        UILabel *styleOneLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 200, 20)];
        styleOneLab.text = [NSString stringWithFormat:@"%@个月",tixingTimeArr[indexPath.row][@"cycleTime"]];
        styleOneLab.tag = indexPath.row + 10;
        styleOneLab.font = Font14;
        [cell.contentView addSubview:styleOneLab];
        
        if (imageOne.tag == [StringOne intValue]+ 10) {
            imageOne.hidden = NO;
            styleOneLab.textColor = greenC;
        }else{
            imageOne.hidden = YES;
            styleOneLab.textColor = titColor;
        }

        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == timeTableview) {
        heiseView.hidden = YES;
        tabbarView.hidden = YES;
        StringOne = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        tixingTime = [NSString stringWithFormat:@"%@",tixingTimeArr[indexPath.row][@"days"]];
        NSString *nameStr = [NSString stringWithFormat:@"%@个月",tixingTimeArr[indexPath.row][@"cycleTime"]];
        [btns setTitle:nameStr forState:normal];
        timeTableview.hidden = YES;
        [tixingArr removeAllObjects];
        [self makeSuiFang];
        [timeTableview reloadData];
    }else{
        timeTableview.hidden = YES;
        
        NSString *strings = tixingArr[indexPath.row][@"hospitalId"];
        NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
        [defau setObject:strings forKey:@"hospitalnumbar"];
        [defau synchronize];
        
        ShuHouSUFangViewController *shuhuo = [[ShuHouSUFangViewController alloc]init];
        shuhuo.numbers = 2;
        shuhuo.infoDic = tixingArr[indexPath.row];
        shuhuo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shuhuo animated:NO];
    }
}
- (void)didSuiFangAddButton:(UIButton *)sender{
    NSDictionary *dic = tixingArr[sender.tag -100];
    
    AddFollow_UpRecordsViewController *shu = [[AddFollow_UpRecordsViewController alloc]init];
    shu.status = [NSString stringWithFormat:@"2"];
    shu.infoDic = dic;
    shu.hospitalID = dic[@"hospitalId"];
    shu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shu animated:NO];
}
- (void)didTimesuifangButton:(UIButton *)sender{
    callbackId = tixingArr[sender.tag][@"callbackId"];
    [self didTimeButton];
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
