//
//  SuiFangTiXingViewController.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SuiFangTiXingViewController.h"
#import "SuiFangTableViewCell.h"
#import "DatePickerView.h"
#import "ShuHouSUFangViewController.h"
#import "AddFollow_UpRecordsViewController.h"

 //
#import "SuiFangJiLuTableViewCell.h"
#import "ShuHouSUFangViewController.h"

@interface SuiFangTiXingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DatePickerViewDelegate>{
    UITableView *SuiTable;
    UITextField *timeTextField;
    NSMutableArray *listArr;
    NSString *callbackId;//回访id
    NSString *timeStr;
    UIView * _backWindowView;
    NSString *timeSearch;
    //
    UITableView *suiListTable;
    NSMutableArray *suiArr;
    int numberss;
    UIView *greenView;//绿色滑块
}
/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;
@property(nonatomic,strong)DatePickerView * pikerView;
@end

@implementation SuiFangTiXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的随访";
    self.view.backgroundColor = SetColor(0xf0f0f0);
    listArr = [NSMutableArray array];
    timeSearch = @"5";
    [self makeAddTableview];
    [self didButton];
    
    //
    numberss -- ;
    suiArr = [NSMutableArray array];
    [self makeSuiFanglist];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 我已随访
- (void)makeSuiFanglist{
    numberss ++;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientchecklist];
    NSArray *keysArray = @[@"sessionid",@"page"];
    NSArray *valueArray = @[sessionIding,[NSString stringWithFormat:@"%d",numberss]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"随访记录%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            if (arrays.count > 0) {
                if (numberss == 1) {
                    [suiArr removeAllObjects];
                    [suiArr addObjectsFromArray:data[@"data"]];
                }else{
                    
                    [suiArr addObjectsFromArray:data[@"data"]];
                }
                
            }else{
                if (suiArr.count == 0) {
                    [self showHint:@"暂无数据"];
                }else{
                    [self showHint:@"暂无更多数据"];
                }
                numberss -- ;
            }
            
        }else{
            numberss --;
            [self showHint:@"暂无数据"];
        }
        [suiListTable reloadData];
        [suiListTable.mj_header endRefreshing];
        [suiListTable.mj_footer endRefreshing];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        numberss -- ;
        [suiListTable.mj_header endRefreshing];
        [suiListTable.mj_footer endRefreshing];
        NSLog(@"随访记录%@",error);
    }];
    
}
#pragma mark add view
- (void)makeAddTableview{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    NSArray *titArr = [NSArray arrayWithObjects:@"随访记录",@"随访提醒", nil];
    for (int a = 0; a < 2; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0+ScreenWidth/2*a , 0, ScreenWidth/2, 40)];
        [btns setTitle:[NSString stringWithFormat:@"%@",titArr[a]] forState:normal];
        [btns setTitleColor:SetColor(0x333333) forState:normal];
        [btns setTitleColor:greenC forState:UIControlStateSelected];
        btns.titleLabel.font = [UIFont systemFontOfSize:14];
        btns.tag = 100 + a;
        [btns addTarget:self action:@selector(didButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btns];
        
        if (a == 0) {
            btns.selected = YES;
            self.selectedBtn = btns;
            greenView = [[UIView alloc]initWithFrame:CGRectMake(40, 38, (ScreenWidth - 160)/2, 2)];
            greenView.backgroundColor = greenC;
            [backView addSubview:greenView];
        }
    }
    
    SuiTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 64 - 50)];
    SuiTable.delegate = self;
    SuiTable.dataSource = self;
    SuiTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:SuiTable];
    SuiTable.hidden = YES;
    
    //
    suiListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 64 - 50)];
    suiListTable.delegate = self;
    suiListTable.dataSource = self;
    suiListTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:suiListTable];
    
    suiListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        numberss = 0;
        [self makeSuiFanglist];
    }];
    
    suiListTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self makeSuiFanglist];
    }];
    
}
- (void)didButtonSelect:(UIButton *)sender{
    sender.selected =! sender.selected;
    
    if (sender!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }else{
        self.selectedBtn.selected = YES;
    }
    
    
    
    if (sender.selected == YES) {
        if (sender.tag == 100) {
            SuiTable.hidden = YES;
            suiListTable.hidden = NO;
        }else{
            SuiTable.hidden = NO;
            suiListTable.hidden = YES;
        }
    }
    
    greenView.frame = CGRectMake(40 + (sender.tag - 100)*(ScreenWidth/2), 38, (ScreenWidth - 160)/2, 2);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"%@",textField.text);
    timeSearch = textField.text;
    [listArr removeAllObjects];
    [self didButton];
    return YES;
}
#pragma mark 随访list
- (void)didButton{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,callbacklist];
    NSArray *keysArray = @[@"sessionid",@"time"];
    NSArray *valueArray = @[sessionIding,timeSearch];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"随访提醒%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [listArr addObjectsFromArray:data[@"data"]];
        }else{
            
        }
        [SuiTable reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"随访提醒%@",error);
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == SuiTable) {
        return listArr.count;
    }else{
        return suiArr.count;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == SuiTable) {
        return 112;
    }else{
        NSDictionary *disa = suiArr[indexPath.row];
        return    74 + floor(([disa[@"forms"] count] +1 + 1)/2) *20;
//        return 114;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == SuiTable) {
        static NSString *cellIdter = @"cellId";
        SuiFangTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
        if (!cellTwo) {
            cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"SuiFangTableViewCell" owner:self options:nil] lastObject];
            cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellTwo.nameLab.text = [NSString stringWithFormat:@"%@",listArr[indexPath.row][@"patientName"]];
        cellTwo.phoneLab.text = [NSString stringWithFormat:@"%@",listArr[indexPath.row][@"phone"]];
        cellTwo.zhangduanLab.text = [NSString stringWithFormat:@"诊断情况：%@",listArr[indexPath.row][@"diagnosis"]];
        cellTwo.timeLab.text = [NSString stringWithFormat:@"随访时间：%@",listArr[indexPath.row][@"callbackTime"]];
        cellTwo.shoushuTimeLab.text = [NSString stringWithFormat:@"手术时间：%@",listArr[indexPath.row][@"surgeryTime"]];
        cellTwo.timeBtn.tag = indexPath.row;
        [cellTwo.timeBtn addTarget:self action:@selector(didTimesuifangButton:) forControlEvents:UIControlEventTouchUpInside];
        cellTwo.zuifangBtn.tag = 100+indexPath.row;
        [cellTwo.zuifangBtn addTarget:self action:@selector(didSuiFangAddButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cellTwo;
    }else{
        static NSString *cellIdter = @"cellId";
        SuiFangJiLuTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
        if (!cellTwo) {
            cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"SuiFangJiLuTableViewCell" owner:self options:nil] lastObject];
            cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *disa = suiArr[indexPath.row];
        [cellTwo setCellWithdic:disa];
        return cellTwo;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == SuiTable) {
        NSString *strings = listArr[indexPath.row][@"hospnumId"];
        NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
        [defau setObject:strings forKey:@"hospitalnumbar"];
        [defau synchronize];
        
        ShuHouSUFangViewController *shuhuo = [[ShuHouSUFangViewController alloc]init];
        shuhuo.numbers = 2;
        shuhuo.infoDic = listArr[indexPath.row];
        shuhuo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shuhuo animated:NO];
    }else{
        NSString *strings = suiArr[indexPath.row][@"hospnumId"];
        
        NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
        [defau setObject:strings forKey:@"hospitalnumbar"];
        [defau synchronize];
        
        ShuHouSUFangViewController *shu = [[ShuHouSUFangViewController alloc]init];
        shu.numbers = 2;
        shu.infoDic = suiArr[indexPath.row];
        shu.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:shu animated:NO];
    }
    

}
- (void)didSuiFangAddButton:(UIButton *)sender{
//    ShuHouFangShiViewController *huo = [[ShuHouFangShiViewController alloc]init];
//    huo.shuDic = listArr[sender.tag - 100];
//    huo.hidesBottomBarWhenPushed = YES;
//    huo.status = [NSString stringWithFormat:@"3"];
//    huo.returnStr = [NSString stringWithFormat:@"3"];
//    [self.navigationController pushViewController:huo animated:NO];
    NSDictionary *dic = listArr[sender.tag -100];
    AddFollow_UpRecordsViewController *shu = [[AddFollow_UpRecordsViewController alloc]init];
    shu.status = [NSString stringWithFormat:@"3"];
    shu.infoDic = dic;
    shu.hospitalID = dic[@"hospitalId"];
//    shu.hospitalID = dic[@"hospnumId"];
    shu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shu animated:NO];
}
- (void)didTimesuifangButton:(UIButton *)sender{
    callbackId = listArr[sender.tag][@"callbackId"];
    [self didTimeButton];
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
        NSLog(@"随访提醒%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [listArr removeAllObjects];
            [self didButton];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
