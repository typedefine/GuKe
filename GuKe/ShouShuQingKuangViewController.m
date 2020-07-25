//
//  ShouShuQingKuangViewController.m
//  GuKe
//
//  Created by yu on 2017/8/14.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ShouShuQingKuangViewController.h"
#import "DatePickerView.h"
#import "PhotoChoseView.h"
#import "MWPhotoBrowser.h"
#import "ZYQAssetPickerController.h"
#import "TZImagePickerController.h"
#import "ZJNAddOperationRequestModel.h"
@interface ShouShuQingKuangViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,DatePickerViewDelegate,ChoseViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,TZImagePickerControllerDelegate>{
    UITableView *oneTable;
    
    NSString *xingbieStr;//性别
    NSString *nameStr;//姓名
    NSString *ageStr;//年龄
    NSString *hospitalNum;//住院号
    
    NSString *timeStr;//日期
    NSString *dicStr;//主刀医生
    NSString *shoushuNameStr;//手术名称
    NSString *maZuiStr;//麻醉类型
    NSString *maNameStr;//麻醉名字
    NSInteger mazuiNum;
    
    UIImagePickerController *imgPicker;//拍照
    
    NSMutableArray *imgArr;//存放照片的数组
    
    NSMutableArray *mazuiArr;//麻醉类型
    NSMutableArray *mazuiTwoArr;//麻醉数组
    UIView *heiseView;//黑色遮罩层
    UIView *whiteView;//白色视图
    UITableView *TimeTable;
    NSString *numTime;
    int numbers;

    UIView *_backWindowView;
    UITextField  *textFieldshou;//手术名称
    UITextField  *textFieldzhu;//主刀医生
    
    UILabel *labelma;
    
    MWPhotoBrowser *browser;
}
@property (nonatomic,strong)DatePickerView *DatePick;
@property (nonatomic,strong)PhotoChoseView *ChoseView;
@property (nonatomic,strong)ZJNAddOperationRequestModel *model;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIButton *selectsBtn;

@end

@implementation ShouShuQingKuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手术情况";
    
    imgArr = [NSMutableArray array];
    mazuiArr = [NSMutableArray array];
    mazuiTwoArr = [NSMutableArray array];

    mazuiNum = 50;
    timeStr = [NSString stringWithFormat:@""];
    shoushuNameStr = [NSString stringWithFormat:@""];
    maZuiStr = [NSString stringWithFormat:@""];
    dicStr = [NSString stringWithFormat:@""];
    
    nameStr = [NSString stringWithFormat:@"%@",self.shouDic[@"patientName"]];
    ageStr = [NSString stringWithFormat:@"%@",self.shouDic[@"age"]];
    xingbieStr = [NSString stringWithFormat:@"%@",self.shouDic[@"gender"]];
    hospitalNum = [NSString stringWithFormat:@"%@",self.shouDic[@"hospNum"]];
    
    [self makeAddTableview];
    [self makeAddView];
    [self makeMaZuiData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 麻醉类型
- (void)makeMaZuiData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,anesthesialist];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
        NSLog(@"麻醉类型%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [mazuiArr addObjectsFromArray:data[@"data"][@"list1"]];
            [mazuiTwoArr addObjectsFromArray:data[@"data"][@"listjm"]];
            
            maZuiStr = [NSString stringWithFormat:@"%@",mazuiArr[0][@"uid"]];
            [TimeTable reloadData];

        }
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"麻醉类型%@",error);
        [self hideHud];
        
    }];

}
- (void)makeAddTableview{
    oneTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    oneTable.delegate = self;
    oneTable.dataSource = self;
    oneTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:oneTable];
}

- (void)makeAddView{
    //
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [self.view addSubview:heiseView];
    heiseView.hidden = YES;
    
    //
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(30, 110, ScreenWidth - 60, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 8;
    [self.view addSubview:whiteView];
    whiteView.hidden = YES;
    
    UIView *viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 30)];
    viewOne.backgroundColor = SetColor(0xf0f0f0);
    [whiteView addSubview:viewOne];
    
    UIButton *btnOne = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btnOne setTitle:@"取消" forState:normal];
    [btnOne setTitleColor:titColor forState:normal];
    [btnOne addTarget:self action:@selector(didCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btnOne];
    
    UIButton *btnTwo = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60 - 50, 0, 50, 30)];
    [btnTwo setTitle:@"确定" forState:normal];
    [btnTwo setTitleColor:greenC forState:normal];
    [btnTwo addTarget:self action:@selector(didOkButton) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btnTwo];
    
    
    TimeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth - 60, 170)];
    TimeTable.delegate = self;
    TimeTable.dataSource = self;
    TimeTable.tableFooterView = [[UIView alloc]init];
    [whiteView addSubview:TimeTable];
    
    
}
#pragma mark 取消按钮
- (void)didCancelButton{
    heiseView.hidden = YES;
    whiteView.hidden = YES;
    
}

#pragma mark 确定按钮
- (void)didOkButton{
    
    heiseView.hidden = YES;
    whiteView.hidden = YES;
    [oneTable reloadData];
}

#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == oneTable) {
        UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
        greenImg.image = [UIImage imageNamed:@"矩形-6"];
        [heardView addSubview:greenImg];
        NSArray *arrays = [NSArray arrayWithObjects:@"患者基本信息",@"手术信息",@"手术麻醉",@"器械合格证", nil];
        UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12, 100, 20)];
        titlLab.text = [NSString stringWithFormat:@"%@",arrays[section]];
        titlLab.font = [UIFont systemFontOfSize:14];
        titlLab.textColor = SetColor(0x1a1a1a);
        [heardView addSubview:titlLab];
        
        CGRect whiteRect = [titlLab boundingRectWithInitSize:titlLab.frame.size];
        titlLab.frame  = CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12,whiteRect.size.width, 20);
        
        if (section == 3 ) {
            UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlLab.frame) + 5, 15, 18, 16)];
            images.image = [UIImage imageNamed:@"上传图片123"];
            [heardView addSubview:images];
        }
        return heardView;
    }else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == oneTable) {
        return 4;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == oneTable) {
        if (section == 0) {
            return 4;
        }else  if(section == 1){
            return 6;
        }else if (section == 2){
            return 1;
        }else{
            return 1;
        }

    }else{
        return mazuiTwoArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == oneTable) {
        return 44;
    }else{
        return 0.01;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == oneTable) {
        if (indexPath.section == 0) {
            return 40;
        }else if(indexPath.section == 1){
            return 40;
        }else if (indexPath.section == 2){
            return 100;
        }else{
            if ((imgArr.count + 1)%4 == 0) {
                return ((ScreenWidth - 60)/4 + 20) * (imgArr.count + 1)/4 + 15;
            }else{
                return ((ScreenWidth - 60)/4 + 20) * ((imgArr.count + 1)/4 + 1)+ 15;
            }
        }

    }else{
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == oneTable) {
        if (section == 3) {
            return 140;
        }else{
            return 0.01;
        }
    }else{
        return 0.01;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == oneTable) {
        if (section == 3) {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
            UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, ScreenWidth - 60, 44)];
            btns.backgroundColor = greenC;
            btns.layer.masksToBounds = YES;
            btns.layer.cornerRadius = 20;
            [btns setTitle:@"提交" forState:normal];
            btns.titleLabel.font = [UIFont systemFontOfSize:14];
            [btns setTitleColor:[UIColor whiteColor] forState:normal];
            [btns addTarget:self action:@selector(didNextBtn) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:btns];
            return footView;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==oneTable) {
        static NSString *cellTwo= @"cellTwo";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0) {
            NSArray *titlaArr = @[@"姓名",@"性别",@"年龄",@"住院号"];
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 25)];
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.textColor = titColor;
            titleLab.text = [NSString stringWithFormat:@"%@",titlaArr[indexPath.row]];
            [cell.contentView addSubview:titleLab];
            if (indexPath.row == 0) {
                UILabel *NameLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 0, 90, 40)];
                NameLab.textAlignment = NSTextAlignmentRight;
                NameLab.font = [UIFont systemFontOfSize:14];
                NameLab.textColor = detailTextColor;
                if ([Utile stringIsNil:nameStr]) {
                    
                }else{
                    NameLab.text = nameStr;
                }
                [cell.contentView addSubview:NameLab];
                
            }else if (indexPath.row == 1){
                NSArray *xingbieArr = [NSArray arrayWithObjects:@"男",@"女", nil];
                for (int a = 0; a < 2; a ++) {
                    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth - 100) + 50 * a, 12, 20, 20)];
                    [btns setImage:[UIImage imageNamed:@"性别_未选中"] forState:normal];
                    [btns setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
                    btns.tag = a + 100;
                    
                    [btns addTarget:self action:@selector(didXingBieButton:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btns];
                    
                    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btns.frame), 12, 20, 20)];
                    labels.font = [UIFont systemFontOfSize:14];
                    labels.text = [NSString stringWithFormat:@"%@",xingbieArr[a]];
                    labels.textColor = detailTextColor;
                    [cell.contentView addSubview:labels];
                    
                    if ([xingbieStr isEqualToString: @"1"]) {
                        if (a == 0) {
                            btns.selected = YES;
                        }
                    }else if ([xingbieStr isEqualToString:@"0"]){
                        if (a == 1) {
                            btns.selected = YES;
                        }
                    }
                    btns.userInteractionEnabled = NO;
                }
            }else if (indexPath.row == 2){
                UILabel  *AgeLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 0, 140, 40)];
                AgeLab.textColor = detailTextColor;
                AgeLab.font = [UIFont systemFontOfSize:14];
                AgeLab.textAlignment = NSTextAlignmentRight;
                if ([Utile stringIsNil:ageStr]) {
                    
                }else{
                    AgeLab.text = [NSString stringWithFormat:@"%@周岁",ageStr];
                }
                [cell.contentView addSubview:AgeLab];
                
                
            }else{
                UILabel  *HaoLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 0, 140, 40)];
                HaoLab.textColor = detailTextColor;
                HaoLab.textAlignment = NSTextAlignmentRight;
                HaoLab.font = [UIFont systemFontOfSize:14];

                HaoLab.text = hospitalNum;
                [cell.contentView addSubview:HaoLab];
            }
            
        }else if (indexPath.section == 1){
            NSArray *titlaArr = @[@"手术日期",@"手术名称",@"手术入路",@"手术医生",@"第一助手",@"第二助手"];
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 25)];
            titleLab.font = [UIFont systemFontOfSize:14];
            titleLab.textColor = titColor;
            titleLab.text = [NSString stringWithFormat:@"%@",titlaArr[indexPath.row]];
            [cell.contentView addSubview:titleLab];
            if (indexPath.row == 0) {
                UILabel *endTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 0, 140, 40)];
                endTimeLab.textColor = detailTextColor;
                endTimeLab.textAlignment = NSTextAlignmentRight;
                endTimeLab.font = [UIFont systemFontOfSize:14];
                if ([Utile stringIsNil:timeStr]) {
                    endTimeLab.text = @"请输入手术日期";
                }else{
                    endTimeLab.text = timeStr;
                }
                [cell.contentView addSubview:endTimeLab];
                
            }else if (indexPath.row == 1){
                textFieldshou = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 0, 140, 40)];
                textFieldshou.delegate = self;
                textFieldshou.textColor = detailTextColor;
                textFieldshou.textAlignment = NSTextAlignmentRight;
                textFieldshou.font = [UIFont systemFontOfSize:14];
                textFieldshou.placeholder = @"请输入手术名称";
                [textFieldshou setValue:detailTextColor forKeyPath:@"_placeholderLabel.textColor"];
                if ([Utile stringIsNil:shoushuNameStr]) {
                    
                }else{
                    textFieldshou.text = shoushuNameStr;
                }
                
                [cell.contentView addSubview:textFieldshou];
                
            }else{
                textFieldzhu = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 0, 140, 40)];
                textFieldzhu.delegate = self;
                textFieldzhu.textColor = detailTextColor;
                textFieldzhu.textAlignment = NSTextAlignmentRight;
                textFieldzhu.font = [UIFont systemFontOfSize:14];
                textFieldzhu.placeholder = @"请输入主刀医生";
                [textFieldzhu setValue:detailTextColor forKeyPath:@"_placeholderLabel.textColor"];
                if ([Utile stringIsNil:dicStr]) {
                    
                }else{
                    textFieldzhu.text = dicStr;
                }
                
                [cell.contentView addSubview:textFieldzhu];
                
            }
        }else if (indexPath.section == 2){
            UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
            labels.font = [UIFont systemFontOfSize:14];
            labels.textColor = titColor;
            labels.text = [NSString stringWithFormat:@"麻醉类型"];
            [cell.contentView addSubview:labels];
            
            NSArray *titArr= [NSArray arrayWithObjects:@"全麻",@"硬膜外麻醉",@"局部麻醉", nil];
            for (int a = 0; a < 3;  a ++) {
                
                UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(10 + (20 + 100)* (a%2), 40 + 30 *(a/2), 20, 20)];
                [btns setImage:[UIImage imageNamed:@"性别_未选中"] forState:normal];
                [btns setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
                btns.tag = 50 + a;
                [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btns];
                if (mazuiNum == btns.tag) {
                    btns.selected = YES;
                    self.selectsBtn = btns;
                }
                
                UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(30 + 120*(a %2), 40 + 30 *(a/2), 80, 20)];
                labels.textColor = detailTextColor;
                labels.font = [UIFont systemFontOfSize:14];
                labels.text = [NSString stringWithFormat:@"%@",titArr[a]];
                [cell.contentView addSubview:labels];
                
            }
            
            labelma = [[UILabel alloc]initWithFrame:CGRectMake(150, 70, 100, 20)];
            if ([Utile stringIsNil:maNameStr]) {
                labelma.hidden = YES;
            }else{
                
                labelma.text = [NSString stringWithFormat:@"%@",maNameStr];
                labelma.hidden = NO;
            }
            
            labelma.textColor = SetColor(0x999999);
            labelma.font = [UIFont systemFontOfSize:14];
            labelma.tag = 1000;
            [cell.contentView addSubview:labelma];
            
            UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 20, 75, 10, 6)];
            imag.image = [UIImage imageNamed:@"箭头_下"];
            [cell.contentView addSubview:imag];
            
        }else{
            for (int a = 0; a < imgArr.count + 1; a ++) {
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(12 + ((ScreenWidth - 60)/4 + 12)*(a %4), 12 + ((ScreenWidth - 60)/4 + 12)*(a/4), (ScreenWidth - 60)/4, (ScreenWidth - 60)/4)];
                
                [cell.contentView addSubview:img];
                
                UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (ScreenWidth - 60)/4 +  ((ScreenWidth - 60)/4 + 12)*(a %4) - 10, 2 + ((ScreenWidth - 60)/4 + 12)*(a/4), 20, 20)];
                deleteBtn.tag = 10 + a;
                img.tag = 20+a;
                [deleteBtn addTarget:self action:@selector(didDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:deleteBtn];
                
                if (a == imgArr.count) {
                    deleteBtn.hidden = YES;
                    img.image = [UIImage imageNamed:@"上传图片"];
                    [Utile addClickEvent:self action:@selector(previewImageViewButtonClick:) owner:img];
                }else{
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删"] forState:normal];
                    img.image = imgArr[a];
                    [Utile addClickEvent:self action:@selector(showImage:) owner:img];
                }
            }
        }
        return cell;

    }else{
        static NSString *cellThree= @"cellThree";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellThree];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 40)];
        timeLab.font = [UIFont systemFontOfSize:14];
        
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.tag = 200 + indexPath.row;
        if (timeLab.tag == [numTime intValue]) {
            timeLab.textColor = greenC;
        }else{
            timeLab.textColor = titColor;
        }
        timeLab.text = [NSString stringWithFormat:@"%@",mazuiTwoArr[indexPath.row][@"anesthesiaName"]];
        [cell.contentView addSubview:timeLab];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == oneTable) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [textFieldzhu resignFirstResponder];
                [textFieldshou resignFirstResponder];
                [self didTimeButton];
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                if ((mazuiNum == 50)||(mazuiNum == 51)) {
                    
                }else{
                    heiseView.hidden = NO;
                    whiteView.hidden = NO;
                }
                
            }
        }
    }else{
        
        numTime = [NSString stringWithFormat:@"%ld",indexPath.row + 200];
        maZuiStr = [NSString stringWithFormat:@"%@",mazuiTwoArr[indexPath.row][@"uid"]];
        maNameStr = [NSString stringWithFormat:@"%@",mazuiTwoArr[indexPath.row][@"anesthesiaName"]];
        [TimeTable reloadData];
    }
}
#pragma mark 添加 图片按钮
-(void)previewImageViewButtonClick:(UIGestureRecognizer *)recognizer{
    NSLog(@"******");
    [self makeChosePhoto];
}
#pragma mark 图片上面的删除按钮点击事件
- (void)didDeleteButton:(UIButton *)sender{
    [imgArr removeObjectAtIndex:sender.tag- 10];
    [oneTable reloadData];
    
    NSLog(@"%ld",(long)sender.tag);
}
#pragma mark 选择麻醉类型
- (void)didButton:(UIButton *)sender{
    sender.selected =! sender.selected;
    mazuiNum =  sender.tag;
    if (sender == _selectsBtn) {
        self.selectsBtn.selected = NO;
        sender.selected = YES;
        self.selectsBtn = sender;
    }else{
        self.selectsBtn.selected = YES;
    }
    maZuiStr = [NSString stringWithFormat:@"%@",mazuiTwoArr[sender.tag - 50][@"uid"]];
    
    if (sender.tag == 50) {
        labelma.hidden = YES;
    }else if (sender.tag == 51){
        labelma.hidden = YES;
    }else{
        labelma.hidden = NO;
    }
    
    [oneTable reloadData];
    
}
#pragma mark 选择性别
- (void)didXingBieButton:(UIButton *)sender{
    sender.selected =! sender.selected;
    if (sender != _selectBtn) {
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
    }else{
        self.selectBtn.selected = YES;
    }
    
    if (sender.tag == 100) {
        xingbieStr = [NSString stringWithFormat:@"1"];
    }else{
        xingbieStr = [NSString stringWithFormat:@"0"];
    }
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
    timeStr = [NSString stringWithFormat:@"%@", date];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
    [oneTable reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)[textField superview].superview;
    NSIndexPath *indexpath = [oneTable indexPathForCell:cell];
    if (indexpath.section == 0) {
       
    }else if (indexpath.section == 1){
        if (indexpath.row == 1) {
            shoushuNameStr = textField.text;
        }else if (indexpath.row == 2){
            dicStr = textField.text;
        }
    }
}
#pragma mark  选择照片
- (void)makeChosePhoto{
    if(_ChoseView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        [self.view addSubview:_backWindowView];
        _ChoseView = [PhotoChoseView makeAddButton];
        _ChoseView.delegate = self;
        _ChoseView.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 160);
        [self.view addSubview:_ChoseView];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _ChoseView.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _ChoseView.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 160);
        } completion:^(BOOL finished) {
            [self.ChoseView removeFromSuperview];
            self.ChoseView = nil;
        }];
    }
    
}
#pragma 头像 从系统相册选择按钮
- (void)makeSelectBtnOne{
    
    TZImagePickerController *tzController = [[TZImagePickerController alloc]initWithMaxImagesCount:16-imgArr.count delegate:self];
    tzController.allowPreview = YES;
    tzController.allowPickingVideo = NO;
    tzController.allowPickingGif = NO;
    tzController.allowPickingOriginalPhoto = NO;
    [tzController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [imgArr addObjectsFromArray:photos];
        [oneTable reloadData];
        
    }];
    
    [self presentViewController:tzController animated:NO completion:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
        } completion:^(BOOL finished) {
            [_ChoseView removeFromSuperview];
            _ChoseView = nil;
        }];
    }];
}

#pragma 头像 拍照按钮
- (void)makeSelectBtnTwo{
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
        
    }
    
    imgPicker.delegate = self;
    imgPicker.hidesBottomBarWhenPushed = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [self.ChoseView removeFromSuperview];
        self.ChoseView = nil;
    }];
    
}
#pragma 头像 取消按钮
- (void)makeSelectBtnThree{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [self.ChoseView removeFromSuperview];
        self.ChoseView = nil;
    }];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *imgage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [imgArr addObject:imgage];
    
    [oneTable reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
}
#pragma mark 提交按钮
- (void)didNextBtn{
    if (imgArr.count > 0) {
        NSMutableArray *imageStringArr = [NSMutableArray array];
        for (int i = 0; i <imgArr.count; i ++) {
            NSData *data = UIImageJPEGRepresentation([Utile fixOrientation:imgArr[i]], proportion);
            NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [imageStringArr addObject:imageString];
        }
        NSString *path = [imageStringArr componentsJoinedByString:@","];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,uploadimageUpload];
        NSArray *keysArray = @[@"fromFile"];
        NSArray *valueArray = @[path];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            NSLog(@"图片上传%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                NSArray *array = [NSArray arrayWithArray:data[@"data"]];
                NSString *pathss = [array componentsJoinedByString:@","];
                [self makeTiJiao:pathss];
                
            }else{
                [self hideHud];
                [self showHint:@"提交失败请重试"];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"图片上传%@",error);
        }];
    }else{
        [self showHint:@"请上传器械合格证"];
        return;
    }
}
- (void)makeTiJiao:(NSString *)paths{
    NSString *shoushuid;
    shoushuid = [NSString stringWithFormat:@"%@",self.shouDic[@"hospnumId"]];
    if ([Utile stringIsNil:shoushuid]) {
        NSUserDefaults *dau = [NSUserDefaults standardUserDefaults];
        shoushuid = [NSString stringWithFormat:@"%@",[dau objectForKey:@"hospitalnumbar"]];
        if ([Utile stringIsNilZero:shoushuid]) {
            return;
        }
    }
    //start
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientsurgical_save];
    NSArray *keysArray = @[@"sessionid",@"surgeryTime",@"surgeryName",@"attr2",@"anesthesiaId",@"qx",@"hospnumId"];
    NSArray *valueArray = @[sessionIding,timeStr,shoushuNameStr,dicStr,maZuiStr,paths,shoushuid];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"手术记录提交%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshShouShuInfo" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MainViewController" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            
        }
        [self hideHud];
        [self showHint:data[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"手术记录提交%@",error);
    }];
    //end
}
-(void)showImage:(UIGestureRecognizer *)recognizer{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    browser.hidesBottomBarWhenPushed = YES;
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:imageView.tag-20];
    [self.navigationController pushViewController:browser animated:NO];
}
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return imgArr.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photot = [MWPhoto photoWithImage:imgArr[index]];
    return photot;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
