//
//  AddFollow_UpRecordsViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/10.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "AddFollow_UpRecordsViewController.h"
#import "ZJNSingleSelectTableViewCell.h"
#import "ZJNPatientBodyInfoTableViewCell.h"
#import "ZJNTitleAndTextViewTableViewCell.h"
#import "ZJNGradeTableViewCell.h"
#import "PingfenModel.h"
#pragma mark--评分页面
#import "harrisPingfenViewController.h"
#import "HssPingfenViewController.h"
#import "SfPingfenViewController.h"
#import "DatePickerView.h"
#import "ZJNUploadInvoicesViewController.h"
@interface AddFollow_UpRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNPatientBodyInfoDelegate,ZJNTitleAndTextViewTableViewDelegate,ZJNGradeTableViewCellDelegate,DatePickerViewDelegate>
{
    UITableView *_tableView;
    NSArray     *titleArr;
    NSString    *dateStr;//手术日期
    NSString    *tiWenStr;//体温
    NSString    *pulseStr;//血压
    NSString    *breatheStr;//呼吸
    NSString    *highBP;//高血压
    NSString    *lowBP;//低血压
    NSString    *harris;
    NSString    *harrisuid;
    NSString    *hss;
    NSString    *hssuid;
    NSString    *sf_12;
    NSString    *sfuid;
    NSString    *check;
    CGFloat      cellHeight;
    
    UIView      *_backWindowView;
    
    CGFloat      pingfencellHeight;
    NSMutableArray * pingfenArray; //评分数据
}
@property (nonatomic,strong)DatePickerView *DatePick;
@end

@implementation AddFollow_UpRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"术后访视";
    [self initInfoStr];
    titleArr = @[@"姓名",@"",@"年龄",@"住院号",@"日期"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self makePingData];
    // Do any additional setup after loading the view.
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
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
            return pingfencellHeight;
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
        [nextButton setTitle:@"下一步" forState:normal];
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
        if (indexPath.row == 1) {
            static NSString *cellid = @"cellid";
            ZJNSingleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNSingleSelectTableViewCell" owner:self options:nil]lastObject];
            }
            NSString *gender = [NSString stringWithFormat:@"%@",self.infoDic[@"gender"]];
            if ([gender isEqualToString:@"1"]) {
                cell.leftButton.selected = YES;
            }else if ([gender isEqualToString:@"0"]){
                cell.rightButton.selected = YES;
            }
            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *cellid = @"celliD";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 20)];
                titleLabel.font = Font14;
                titleLabel.textColor = SetColor(0x1a1a1a);
                titleLabel.tag = 10;
                [cell.contentView addSubview:titleLabel];
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, ScreenWidth-130, 20)];
                contentLabel.textAlignment = NSTextAlignmentRight;
                contentLabel.font = Font14;
                contentLabel.tag = 11;
                [cell.contentView addSubview:contentLabel];
            }
            UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
            UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:11];
            
            titleLabel.text = titleArr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 4) {
                cell.userInteractionEnabled = YES;
                if (dateStr.length>0) {
                    contentLabel.textColor = SetColor(0x1a1a1a);
                    contentLabel.text = dateStr;
                }else{
                    contentLabel.textColor = SetColor(0x666666);
                    contentLabel.text = @"请选择时间";
                }
            }else{
                cell.userInteractionEnabled = NO;
                cell.detailTextLabel.textColor = SetColor(0x1a1a1a);
                if (indexPath.row == 0) {
                    contentLabel.text = self.infoDic[@"patientName"];
                }else if (indexPath.row == 2){
                    contentLabel.text = [NSString stringWithFormat:@"%@",self.infoDic[@"age"]];
                }else{
                    
                    
                    if ((self.hopitalNumbers.length == 0)||[self.hopitalNumbers isEqualToString:@"(null)"]||[self.hopitalNumbers isEqualToString:@""]) {
                        contentLabel.text = self.infoDic[@"hospNum"];
                    }else{

                        contentLabel.text = self.hopitalNumbers;
                    }
                   
                }
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        static NSString *cellid = @"cellID";
        ZJNPatientBodyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNPatientBodyInfoTableViewCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        cell.tiWenTextField.text = tiWenStr;
        cell.pulseTextField.text = pulseStr;
        cell.breatheTextField.text = breatheStr;
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
//            cell.harrisString = harris;
//            cell.HSSString = hss;
//            cell.SF_12String = sf_12;
            cell.PingfenArray = pingfenArray;
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
            cell.text = check;
            cell.textView.placeholder = @"请输入专科检查(多行输入)";
            cell.textView.textAlignment = NSTextAlignmentLeft;
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.row == 4) {
        NSLog(@"选择手术日期");
        [self didTimeButton];
    }
}
#pragma mark--ZJNTitleAndTextViewTableViewDelegate
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath{
    check = text;
}
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath{
    cellHeight = MAX(44, height);
}
#pragma mark--ZJNPatientBodyInfoDelegate
-(void)zjnPatientBodyInfoTextDieldEndEditingWithDictionary:(NSDictionary *)dic{
    NSString *str = dic[@"type"];
    if ([str isEqualToString:@"0"]) {
        tiWenStr = dic[@"text"];
    }else if ([str isEqualToString:@"1"]){
        pulseStr = dic[@"text"];
    }else if ([str isEqualToString:@"2"]){
        breatheStr = dic[@"text"];
    }else if ([str isEqualToString:@"3"]){
        highBP = dic[@"text"];
    }else{
        lowBP = dic[@"text"];
    }
}
-(void)initInfoStr{
    dateStr = @"";
    tiWenStr = @"";
    pulseStr = @"";
    breatheStr = @"";
    highBP = @"";
    lowBP = @"";
    harris = @"";
    harrisuid = @"";
    hss = @"";
    hssuid = @"";
    sf_12 = @"";
    sfuid = @"";
    check = @"";
    cellHeight = 44;
}
#pragma mark--ZJNGradeTableViewCellDelegate
-(void)gradeButtonClickWithGradeType:(NSInteger)index{
   
    PingfenModel * model =    pingfenArray[index];
    
    harrisPingfenViewController *harr = [[harrisPingfenViewController alloc]init];
    
    harr.returnValueBlock = ^(NSDictionary *harrisDic) {
        
        model.saveColumn = harrisDic[@"saveColumn"];
        model.saveNumber = harrisDic[@"saveNumber"];
        [pingfenArray replaceObjectAtIndex:index withObject:model];
        [_tableView reloadData];
    };
    
    harr.saveNumber = model.saveNumber;
    harr.formId = model.formId;
    harr.saveColumn = model.saveColumn;
    harr.formName = model.formName;
    
    
    harr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:harr animated:NO];
    
//
//
//    if ([gradeType isEqualToString:@"harris"]) {
//        harrisPingfenViewController *harr = [[harrisPingfenViewController alloc]init];
//        harr.returnValueBlock = ^(NSDictionary *harrisDic) {
//            harris = [NSString stringWithFormat:@"%@",harrisDic[@"val"]];
//            harrisuid = [NSString stringWithFormat:@"%@",harrisDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//
////        harr.valStr = [NSString stringWithFormat:@"%@",harris];
////        harr.pfuid = [NSString stringWithFormat:@"%@",harrisuid];
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else if ([gradeType isEqualToString:@"hss"]){
//        HssPingfenViewController *harr = [[HssPingfenViewController alloc]init];
//        harr.returnValueHsBlock = ^(NSDictionary *hssDic) {
//            hss = [NSString stringWithFormat:@"%@",hssDic[@"val"]];
//            hssuid = [NSString stringWithFormat:@"%@",hssDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//
//        harr.valStr = [NSString stringWithFormat:@"%@",hss];
//        harr.pfuid = [NSString stringWithFormat:@"%@",hssuid];
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else{
//        SfPingfenViewController *harr = [[SfPingfenViewController alloc]init];
//        harr.returnValueSfBlock = ^(NSDictionary *sfValueDic) {
//            sf_12 = [NSString stringWithFormat:@"%@",sfValueDic[@"val"]];
//            sfuid = [NSString stringWithFormat:@"%@",sfValueDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//
//        harr.valStr =[NSString stringWithFormat:@"%@",sf_12];
//        harr.pfuid = [NSString stringWithFormat:@"%@",sfuid];
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
    dateStr = [NSString stringWithFormat:@"%@", date];
    
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
   
    if ([NSString IsNullStr:dateStr]) {
        [self showHint:@"请填写日期后提交!"];
        return;
    }
   
    NSDictionary *dic = @{@"sessionid":sessionIding,@"hospnumId":self.hospitalID,@"createTime":dateStr,@"temperature":tiWenStr,@"pulse":pulseStr,@"breathe":breatheStr,@"pressure":[NSString stringWithFormat:@"%@,%@",highBP,lowBP],@"check":check,@"harris":harris,@"hss":hss,@"sf":sf_12,@"status":self.status,@"harrisuid":harrisuid,@"hssuid":hssuid,@"sfuid":sfuid};
    
    
    ZJNUploadInvoicesViewController *view = [[ZJNUploadInvoicesViewController alloc]initWithUploadInvoicesType:UploadInvoicesFromAddFollow_UP];
    view.fInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
   
    if (pingfenArray.count > 0) {
        NSMutableArray * formsArray  = [[NSMutableArray alloc]init];
        for (PingfenModel * models in pingfenArray) {
            NSString * str = [NSString stringWithFormat:@"%@#%@#%@",models.formId,models.saveNumber,models.saveColumn];
            if (models.saveNumber.length > 0 && ![models.saveNumber isEqualToString:@"(null)"]) {
                [formsArray addObject:str];
            }
        }
        
        NSString * formsStr =[formsArray componentsJoinedByString:@","];
        [view.fInfoDic setObject:formsStr forKey:@"forms"];
    }
    
    view.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:view animated:NO];
}



-(void)makePingData{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,form_list];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    pingfenArray = [[NSMutableArray alloc]init];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        NSLog(@"%@",data);
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            for(NSDictionary * dic in array){
                PingfenModel *model = [PingfenModel yy_modelWithJSON:dic];
                [pingfenArray addObject:model];
            }
            pingfencellHeight = 36 * pingfenArray.count;
            
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    } failure:^(NSError *error) {
        
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
