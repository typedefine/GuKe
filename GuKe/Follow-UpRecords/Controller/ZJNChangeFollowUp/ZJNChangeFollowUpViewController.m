//
//  ZJNChangeFollowUpViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/9.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangeFollowUpViewController.h"
#import "ZJNPatientBodyInfoTableViewCell.h"
#import "ZJNTitleAndTextViewTableViewCell.h"
#import "ZJNGradeTableViewCell.h"
#pragma mark--评分页面
#import "harrisPingfenViewController.h"
#import "HssPingfenViewController.h"
#import "SfPingfenViewController.h"
#import "DatePickerView.h"
#import "PingfenModel.h"
#import "ZJNTitleAndTextfieldTableViewCell.h"
@interface ZJNChangeFollowUpViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNPatientBodyInfoDelegate,ZJNTitleAndTextViewTableViewDelegate,ZJNGradeTableViewCellDelegate,DatePickerViewDelegate>
{
    UITableView *_tableView;
    CGFloat      cellHeight;
    UIView      *_backWindowView;
    NSString    *highBP;//高血压
    NSString    *lowBP;//低血压
}
@property (nonatomic,strong)DatePickerView *DatePick;
@end

@implementation ZJNChangeFollowUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"术后访视";
    cellHeight = 44;
    NSArray *presureArr = [self.model.pressure componentsSeparatedByString:@"/"];
    highBP = presureArr[0];
    lowBP  = presureArr[1];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 140;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 200;
    }else{
        if (indexPath.row == 0) {
            return 36 * [self.model.PingfenArray count];
        }else{
            return MAX(44, cellHeight);
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return nil;
    }
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
    greenImg.image = [UIImage imageNamed:@"矩形-6"];
    [heardView addSubview:greenImg];
    
    UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 0, 120, 44)];
    titlLab.font = Font14;
    titlLab.textColor = SetColor(0x1a1a1a);
    [heardView addSubview:titlLab];
    
    if (section == 0) {
        titlLab.text = @"患者基本资料";
    }else{
        titlLab.text = @"生命体征";
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(30, 60, ScreenWidth-60, 44);
        nextButton.backgroundColor = greenC;
        [Utile makeCorner:22 view:nextButton];
        [nextButton setTitle:@"确定" forState:normal];
        nextButton.titleLabel.font = Font14;
        [nextButton setTitleColor:[UIColor whiteColor] forState:normal];
        [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:nextButton];
        return footerView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellid = @"info";
        ZJNTitleAndTextfieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNTitleAndTextfieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"随访日期";
        cell.textField.placeholder = @"请选择日期";
        [cell.textField setEnabled:NO];
        cell.textField.text = self.model.visitTime;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellid = @"cellID";
        ZJNPatientBodyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNPatientBodyInfoTableViewCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        cell.tiWenTextField.text = self.model.temperature;
        cell.pulseTextField.text = self.model.pulse;
        cell.breatheTextField.text = self.model.breathe;
        cell.hightBloodPressureTextField.text = highBP;
        cell.lowBloodPressureTextField.text = lowBP;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            static NSString *cellid = @"celLID";
            ZJNGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNGradeTableViewCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
//            cell.harrisString = self.model.harris;
//            cell.HSSString = self.model.hss;
//            cell.SF_12String = self.model.sf;
            cell.PingfenArray  = self.model.PingfenArray;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *cellid = @"ceLLID";
            ZJNTitleAndTextViewTableViewCell *cell = [tableView expandableTitleAndTextViewTextCellWithId:cellid];
            if (!cell) {
                cell = [[ZJNTitleAndTextViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"专科检查";
            cell.text = self.model.checks;
            cell.textView.placeholder = @"请输入专科检查(多行输入)";
            cell.textView.textAlignment = NSTextAlignmentLeft;
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"选择手术日期");
        [self didTimeButton];
    }
}
#pragma mark--ZJNTitleAndTextViewTableViewDelegate
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath{
    self.model.checks = text;
}
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath{
    cellHeight = MAX(44, height);
}
#pragma mark--ZJNPatientBodyInfoDelegate
-(void)zjnPatientBodyInfoTextDieldEndEditingWithDictionary:(NSDictionary *)dic{
    NSString *str = dic[@"type"];
    if ([str isEqualToString:@"0"]) {
        self.model.temperature = dic[@"text"];
    }else if ([str isEqualToString:@"1"]){
        self.model.pulse = dic[@"text"];
    }else if ([str isEqualToString:@"2"]){
        self.model.breathe = dic[@"text"];
    }else if ([str isEqualToString:@"3"]){
        //高压
        highBP = dic[@"text"];
    }else{
        lowBP = dic[@"text"];
    }
}

#pragma mark--ZJNGradeTableViewCellDelegate
-(void)gradeButtonClickWithGradeType:(NSInteger)index{
    PingfenModel * model =    self.model.PingfenArray[index];
    
    harrisPingfenViewController *harr = [[harrisPingfenViewController alloc]init];
    
    harr.returnValueBlock = ^(NSDictionary *harrisDic) {
        
        model.saveColumn = harrisDic[@"saveColumn"];
        model.saveNumber = harrisDic[@"saveNumber"];
        [ self.model.PingfenArray replaceObjectAtIndex:index withObject:model];
        [_tableView reloadData];
    };
    
    harr.saveNumber = model.saveNumber;
    harr.formId = model.formId;
    harr.saveColumn = model.saveColumn;
    harr.formName = model.formName;
    
    
    harr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:harr animated:NO];
        
//        harr.valStr = [NSString stringWithFormat:@"%@",self.model.harris];
//        harr.pfuid = [NSString stringWithFormat:@"%@",self.model.harrisuid];
        
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else if ([gradeType isEqualToString:@"hss"]){
//        HssPingfenViewController *harr = [[HssPingfenViewController alloc]init];
//        harr.returnValueHsBlock = ^(NSDictionary *hssDic) {
//            self.model.hss = [NSString stringWithFormat:@"%@",hssDic[@"val"]];
//            self.model.hssuid = [NSString stringWithFormat:@"%@",hssDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr = [NSString stringWithFormat:@"%@",self.model.hss];
//        harr.pfuid = [NSString stringWithFormat:@"%@",self.model.hssuid];
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else{
//        SfPingfenViewController *harr = [[SfPingfenViewController alloc]init];
//        harr.returnValueSfBlock = ^(NSDictionary *sfValueDic) {
//            self.model.sf = [NSString stringWithFormat:@"%@",sfValueDic[@"val"]];
//            self.model.sfuid = [NSString stringWithFormat:@"%@",sfValueDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr =[NSString stringWithFormat:@"%@",self.model.sf];
//        harr.pfuid = [NSString stringWithFormat:@"%@",self.model.sfuid];
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }
}
#pragma mark 开始时间
- (void)didTimeButton{
    if(_DatePick==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        
        [self.view addSubview:_backWindowView];
        _DatePick = [DatePickerView datePickerView];
        _DatePick.delegate = self;
        _DatePick.type = 0;
        _DatePick.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        [self.view addSubview:_DatePick];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _DatePick.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _DatePick.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
            [_DatePick removeFromSuperview];
            _DatePick = nil;
        }];
    }
    
}
- (void)getcancel{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    self.model.createTime = [NSString stringWithFormat:@"%@", date];
    self.model.visitTime = [NSString stringWithFormat:@"%@", date];

    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
    [_tableView reloadData];
}
#pragma mark--跳转到下一级页面
-(void)nextButtonClick:(UIButton *)button{

    self.model.pressure = [@[highBP,lowBP] componentsJoinedByString:@","];
    NSDictionary *dic = [self returnToDictionaryWithModel:self.model];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,updatecheck];
 
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *string = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([string isEqualToString:@"0000"]) {
            
        }
        [self showHint:data[@"message"]];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:@"连接服务器失败"];
    }];

}
-(NSMutableDictionary *)returnToDictionaryWithModel:(ZJNChangeFollowUpRequestModel *)model
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([ZJNChangeFollowUpRequestModel class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setObject:propertyValue forKey:propertyName];
        }else{
            [userDic setObject:@"" forKey:propertyName];
        }
        
    }
    
    if (model.PingfenArray.count > 0) {
        NSMutableArray * formsArray  = [[NSMutableArray alloc]init];
        for (PingfenModel * models in model.PingfenArray) {
            NSString * str = [NSString stringWithFormat:@"%@#%@#%@",models.formId,models.saveNumber,models.saveColumn];
            if (models.saveNumber.length > 0 && ![models.saveNumber isEqualToString:@"(null)"]) {
                [formsArray addObject:str];
            }
        }
        
        NSString * formsStr =[formsArray componentsJoinedByString:@","];
        [userDic setObject:formsStr forKey:@"forms"];
    }
    
    
    free(properties);
//    [userDic removeObjectForKey:@"createTime"];
    return userDic;
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
