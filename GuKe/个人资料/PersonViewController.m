//
//  PersonViewController.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "PersonViewController.h"
#import "ChangeGeRenInfoViewController.h"
#import "ChoseYiYuanViewController.h"
#import "DatePickerView.h"
#import "ZhhuanChangViewController.h"
#import "LSCityChooseView.h"
#import "PhotoChoseView.h"
#import "ZYQAssetPickerController.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate,ChoseViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITableView *mainTableview;
    UIView * _backWindowView;
    NSString *timeStr;//时间
    
    UIView *heiseView;
    UIPickerView *mainPickView;
    UIView *WhiteView;
    NSArray *pickArr;//pickview共用数组
    NSArray *yiyuanArr;//医院类型数组
    NSArray *keshiArr;//科室数组
    NSArray *zhichengArr;//职称数组
    NSString *yiyuanStyle;//医院类型
    NSString *dataStyle;//pickView类型  1 医院  2科室 3 职称
    
    NSArray *chaungchangArr;
    BOOL isEnding;
    
    NSString *doctorName;//姓名
    NSString *gender;//性别
    NSString *birth;//生日
    NSString *email;//邮箱
    NSString *hospitalId;//医院
    NSString *hospitalName;//医院名字
    NSString *clinic;//诊所
    NSString *deptId;//科室
    NSString *deptName;//科室名字
    NSString *titleId;//职称
    NSString *titleName;//职称名字
    NSString *num;//医师证号
    NSString *content;//简介
    NSString *portrait;//头像
    NSString *specialty;//专长
    NSString *phoneStr;//手机号
    NSString * newHosptialName;// 手动输入医院
    NSString * newDeptName;// 手动输入科室
    CGRect zhuanRect;
    CGRect phoneRect;
    
    UIImagePickerController *imgPicker;//拍照
    
    NSMutableArray *imgArr;//存放照片的数组
    NSMutableArray *imgNames;//存放照片的名字
    NSFileManager *fileManager;
    NSDictionary *hospitalDic;
    
    NSString *publicString;
    NSString *publicTwoString;
    NSString *publicThreeString;
    
    NSInteger selectRow;
    NSArray *publicArr;
    NSArray *arrOne;
    

}
@property (nonatomic,strong)PhotoChoseView *ChoseView;
@property(nonatomic,strong)DatePickerView * pikerView;
@property (nonatomic,strong)UIButton *selectBtn;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    imgArr = [NSMutableArray array];
    imgNames = [NSMutableArray array];
    
    doctorName = @"";
    gender = @"";
    birth = @"";
    email = @"";
    hospitalId = @"";
    hospitalName = @"";
    clinic = @"";
    deptId = @"";
    deptName = @"";
    titleId = @"";
    titleName = @"";
    num = @"";
    content = @"";
    portrait = @"";
    specialty = @"";
    phoneStr = @"";
    newDeptName = @"";
    newHosptialName = @"";
    
    yiyuanStyle = [NSString stringWithFormat:@"医院"];
    yiyuanArr = [NSArray arrayWithObjects:@"医院",@"诊所",nil];
    isEnding = YES;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self makeAddTableview];
    [self makePickView];
    
    [self makeDataZhanshi];
    [self makeAddChoseKeshi];
    [self makeZhiCheng];
    // Do any additional setup after loading the view from its nib.
}
//返回按钮点击实现方法
-(void)backButtonClick{
    if (self.pushcoming) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    }
}
#pragma mark 个人资料展示
- (void)makeDataZhanshi{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorshow];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"个人资料展示%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            
            SetChatImgUrl(data[@"data"][@"portrait"]);
            SetChatUserName(data[@"data"][@"doctorName"]);
            Synchronize;
            
            phoneStr = [NSString stringWithFormat:@"%@",data[@"data"][@"phone"]];
            doctorName = [NSString stringWithFormat:@"%@",data[@"data"][@"doctorName"]];
            hospitalName = [NSString stringWithFormat:@"%@",data[@"data"][@"hospitalName"]];
            clinic = [NSString stringWithFormat:@"%@",data[@"data"][@"hospitalName"]];

            
            deptName = [NSString stringWithFormat:@"%@",data[@"data"][@"deptName"]];
            birth = [NSString stringWithFormat:@"%@",data[@"data"][@"birth"]];
            email = [NSString stringWithFormat:@"%@",data[@"data"][@"email"]];
            content = [NSString stringWithFormat:@"%@",data[@"data"][@"content"]];
            num = [NSString stringWithFormat:@"%@",data[@"data"][@"num"]];
            gender = [NSString stringWithFormat:@"%@",data[@"data"][@"gender"]];
            hospitalId = [NSString stringWithFormat:@"%@",data[@"data"][@"hospitalId"]];
            if ([NSString IsNullStr:hospitalId]) {
                hospitalId = @"";
            }
            if ([Utile stringIsNilZero:hospitalId]) {
                yiyuanStyle = [NSString stringWithFormat:@"医院"];
            }else{
                if ([hospitalId isEqualToString:@"0"]) {
                    yiyuanStyle = [NSString stringWithFormat:@"诊所"];
                }else{
                    yiyuanStyle = [NSString stringWithFormat:@"医院"];
                }
                if(![NSString IsNullStr:deptName]){
                    yiyuanStyle = [NSString stringWithFormat:@"医院"];
                }
            }
            [self makeAddChoseKeshi];
            titleName = [NSString stringWithFormat:@"%@",data[@"data"][@"titleName"]];
            deptId = [NSString stringWithFormat:@"%@",data[@"data"][@"deptId"]];
            portrait = [NSString stringWithFormat:@"%@",data[@"data"][@"portrait"]];
            //
            NSMutableArray *zhuanArray = [NSMutableArray array];
            NSMutableArray *zhuanChanAr = [NSMutableArray array];
            arrOne = [NSArray arrayWithArray:data[@"data"][@"specialty"]];
            for (NSDictionary *zhuanDic in arrOne) {
                [zhuanArray addObject:[zhuanDic objectForKey:@"specialtyName"]];
                [zhuanChanAr addObject:[zhuanDic objectForKey:@"uid"]];
                
            }
            chaungchangArr = zhuanArray;
            specialty = [zhuanChanAr componentsJoinedByString:@","];
            //
        }else{
            
        }
        [mainTableview reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"个人资料展示%@",error);
    }];
}
#pragma mark 选择科室 start
- (void)makeAddChoseKeshi{
    if ([hospitalId isEqualToString:@""]||[hospitalId isEqualToString:@"(null)"]||[hospitalId isEqualToString:@"<null>"]||(hospitalId.length == 0)) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,departmentlist];
    NSArray *keysArray = @[@"hospitalId"];
    NSArray *valueArray = @[hospitalId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            keshiArr = [NSArray arrayWithArray:data[@"data"]];
        }else{
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark 选择职称 start
- (void)makeZhiCheng{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,titlelist];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"选择职称%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            zhichengArr = [NSArray arrayWithArray:data[@"data"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"选择职称%@",error);
    }];
}
//end



#pragma mark addtableview
- (void)makeAddTableview{
    mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStyleGrouped];
    mainTableview.delegate = self;
    mainTableview.dataSource = self;
    mainTableview.scrollEnabled = YES;
    mainTableview.backgroundColor = SetColor(0xf0f0f0);
    mainTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:mainTableview];
}
#pragma mark pick start
- (void)makePickView{
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [self.view addSubview:heiseView];
    heiseView.hidden = YES;
    
    WhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 176, ScreenWidth, 176)];
    WhiteView.backgroundColor = [UIColor whiteColor];
    [heiseView addSubview:WhiteView];
    
    UIButton *CancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [CancelBtn setTitle:@"取消" forState:normal];
    CancelBtn.titleLabel.font = Font16;
    [CancelBtn setTitleColor:detailTextColor forState:normal];
    [CancelBtn addTarget:self action:@selector(didCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:CancelBtn];
    
    UIButton *OkBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 0, 80, 43)];
    [OkBtn setTitle:@"完成" forState:normal];
    OkBtn.titleLabel.font = Font16;
    [OkBtn setTitleColor:detailTextColor forState:normal];
    [OkBtn addTarget:self action:@selector(didOKButton) forControlEvents:UIControlEventTouchUpInside];
    [WhiteView addSubview:OkBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
    lineView.backgroundColor = SetColor(0xf0f0f0);
    [WhiteView addSubview:lineView];
    
    mainPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 132)];
    mainPickView.delegate = self;
    mainPickView.dataSource = self;
    [WhiteView addSubview:mainPickView];


}
#pragma mark 取消
- (void)didCancelButton{
    heiseView.hidden = YES;
}
#pragma mark 确定
- (void)didOKButton{
    heiseView.hidden = YES;
    if ([dataStyle isEqualToString:@"1"]) {
        if ([Utile stringIsNil:publicString]) {
            yiyuanStyle = pickArr[0];
        }else{
            
        }
        
        
    }else if([dataStyle isEqualToString:@"2"]){
        if ([Utile stringIsNil:publicTwoString]) {
            deptName = [NSString stringWithFormat:@"%@",pickArr[0][@"deptName"]];
            deptId = [NSString stringWithFormat:@"%@",pickArr[0][@"deptId"]];
        }else{
            
        }
    }else{
        if ([Utile stringIsNil:publicThreeString]) {
            titleId = [NSString stringWithFormat:@"%@",pickArr[0][@"uid"]];
            titleName = [NSString stringWithFormat:@"%@",pickArr[0][@"titleName"]];
        }else{
            
        }
        
    }
    [mainTableview reloadData];
}
#pragma mark  pickview  delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickArr.count;
}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    
    return ScreenWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([dataStyle isEqualToString:@"1"]) {
        publicString = [NSString stringWithFormat:@"%@",pickArr[row]];
        yiyuanStyle = pickArr[row];
        
        NSLog(@"nameStr=%@",yiyuanStyle);
    }else if([dataStyle isEqualToString:@"2"]){
        publicTwoString = [NSString stringWithFormat:@"%@",pickArr[row][@"deptName"]];
        deptName = [NSString stringWithFormat:@"%@",pickArr[row][@"deptName"]];
        deptId = [NSString stringWithFormat:@"%@",pickArr[row][@"deptId"]];
        NSLog(@"nameStr=%@",deptName);
    }else{
        publicThreeString = [NSString stringWithFormat:@"%@",pickArr[row][@"titleName"]];
        titleId = [NSString stringWithFormat:@"%@",pickArr[row][@"uid"]];
        titleName = [NSString stringWithFormat:@"%@",pickArr[row][@"titleName"]];
    }
    
    selectRow = row;
    [pickerView reloadAllComponents];
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([dataStyle isEqualToString:@"1"]) {
        return pickArr[row];
    } else if([dataStyle isEqualToString:@"2"]) {
        return pickArr[row][@"deptName"];
        
    }else{
        return pickArr[row][@"titleName"];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:Font14];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    
    if (row == selectRow) {
        pickerLabel.textColor = greenC;
    }else{
        pickerLabel.textColor = detailTextColor;
    }
    return pickerLabel;
}

//end


#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 43)];
    
    UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
    greenImg.image = [UIImage imageNamed:@"矩形-6"];
    [heardView addSubview:greenImg];
    NSArray *arrays = [NSArray arrayWithObjects:@"基本资料",@"专业资料", nil];
    
    UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 11, 100, 20)];
    titlLab.text = [NSString stringWithFormat:@"%@",arrays[section]];
    titlLab.font = [UIFont systemFontOfSize:14];
    titlLab.textColor = SetColor(0x1a1a1a);
    [heardView addSubview:titlLab];
    return heardView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        if (isEnding) {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
            UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, ScreenWidth - 40, 44)];
            okBtn.backgroundColor = greenC;
            okBtn.layer.masksToBounds = YES;
            okBtn.layer.cornerRadius = 20;
            [okBtn setTitle:@"提交" forState:normal];
            [okBtn setTitleColor:[UIColor whiteColor] forState:normal];
            [okBtn addTarget:self action:@selector(didTiJiaoButton) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:okBtn];
            return footView;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        if (isEnding) {
            return 100;
        }else{
            return 0.0001;
        }
    }else{
        return 0.0001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            if ([Utile stringIsNil:content]) {
                return 44;
            }else{
                return zhuanRect.size.height + 24;
            }
        }else{
            return 44;
        }
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellTwo= @"cellTwo";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *titlaArr;
    if ([yiyuanStyle isEqualToString:@"医院"]) {
        titlaArr = @[@[@"头像",@"姓名",@"性别",@"出生日期",@"手机号码",@"邮箱"],@[@"医院",@"科室",@"职称",@"执业医师证编号",@"专长",@"个人简介"]];
    }else{
        titlaArr = @[@[@"头像",@"姓名",@"性别",@"出生日期",@"手机号码",@"邮箱"],@[@"诊所",@"科室",@"职称",@"执业医师证编号",@"专长",@"个人简介"]];
    }
    
    
    NSArray *titimArr = @[@[@"必填",@"必填",@"必填",@"",@"必填",@""],@[@"",@"必填",@"",@"",@"",@""]];
    //
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = SetColor(0x1a1a1a);
    titleLab.text = [NSString stringWithFormat:@"%@",titlaArr[indexPath.section][indexPath.row]];
    CGRect titRect = [titleLab boundingRectWithInitSize:titleLab.frame.size];
    titleLab.frame = CGRectMake(10, 10, titRect.size.width, 25);
    [cell.contentView addSubview:titleLab];
    
    UIImageView *typeimg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame)+ 3, 10, 5, 5)];
    typeimg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",titimArr[indexPath.section][indexPath.row]]];
    [cell.contentView addSubview:typeimg];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            

            if (isEnding) {
              //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 2, 40, 40)];
                img.layer.masksToBounds = YES;
                img.layer.cornerRadius = 20;
                img.clipsToBounds = YES;
                img.contentMode = UIViewContentModeScaleAspectFill;
                if (imgArr.count == 0) {
                    if ([Utile stringIsNil:portrait]) {
                        
                    }else{
                        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,portrait]] placeholderImage:[UIImage imageNamed:@"个人头像-未认证"]];
                    }
                }else{
                    img.image = imgArr[0];
                }
                [cell.contentView addSubview:img];
                
                UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, 14, 9, 15)];
                jiantouImg.image = [UIImage imageNamed:@"ARROW---RIGHT"];
                [cell.contentView addSubview:jiantouImg];
            }else{
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 2, 40, 40)];
                img.layer.masksToBounds = YES;
                img.layer.cornerRadius = 20;
                img.clipsToBounds = YES;
                img.contentMode = UIViewContentModeScaleAspectFill;

                if (imgArr.count == 0) {
                    img.image = [UIImage imageNamed:@"个人头像-未认证"];
                }else{
                    img.image = imgArr[0];
                }
                
                [cell.contentView addSubview:img];
            }
            
            
        }else if (indexPath.row == 1){
            if (isEnding) {
                UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 0, 80, 44)];
                nameField.placeholder = @"请输入名字";
                nameField.delegate = self;
                nameField.font = [UIFont systemFontOfSize:14];
                nameField.textColor = detailTextColor;
                nameField.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:nameField];
                if ([Utile stringIsNil:doctorName]) {
                    
                }else{
                    nameField.text = doctorName;
                }

            }else{
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 0, 80, 44)];
                nameLab.font = [UIFont systemFontOfSize:14];
                nameLab.textColor = titColor;
                nameLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:nameLab];
                if ([Utile stringIsNil:doctorName]) {
                    
                }else{
                    nameLab.text = doctorName;
                }
            }
            
        }else if (indexPath.row == 2){
            if (isEnding) {
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
                    if ([gender isEqualToString:@"1"]) {
                        if (a == 0) {
                            btns.selected = YES;
                            self.selectBtn = btns;
                        }
                    }else if([gender isEqualToString:@"0"]){
                        if (a == 1) {
                            btns.selected = YES;
                            self.selectBtn = btns;
                        }
                    }
                    
                }
            }else{
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
                    btns.enabled = NO;
                    [cell.contentView addSubview:labels];
                    if ([gender isEqualToString:@"1"]) {
                        if (a == 0) {
                            btns.selected = YES;
                            self.selectBtn = btns;
                        }
                    }else if([gender isEqualToString:@"0"]){
                        if (a == 1) {
                            btns.selected = YES;
                            self.selectBtn = btns;
                        }
                    }
                }
            }
            
            
        }else if (indexPath.row == 3){
            if (isEnding) {
                UIImageView *Images = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 33, 17, 13, 7)];
                Images.image = [UIImage imageNamed:@"箭头_下"];
                [cell.contentView addSubview:Images];
                
                
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 120, 0, 80, 44)];
                nameLab.font = [UIFont systemFontOfSize:14];
                nameLab.textColor = detailTextColor;
                nameLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:nameLab];
                
                if ([Utile stringIsNil:birth]) {
                    
                }else{
                    nameLab.text = birth;
                }

            }else{
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 0, 80, 44)];
                nameLab.font = [UIFont systemFontOfSize:14];
                nameLab.textColor = detailTextColor;
                nameLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:nameLab];
                
                if ([Utile stringIsNil:birth]) {
                    
                }else{
                    nameLab.text = birth;
                }

            }
            
        }else if (indexPath.row == 4){
            UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 9, 0, 26)];
            PhoneLab.font = [UIFont systemFontOfSize:14];
            PhoneLab.textColor = detailTextColor;
            PhoneLab.layer.masksToBounds = YES;
            PhoneLab.layer.cornerRadius = 4;
            PhoneLab.backgroundColor = SetColor(0xf0f0f0);
            PhoneLab.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:PhoneLab];
            if ([Utile stringIsNil:phoneStr]) {
                
            }else{
                PhoneLab.text = phoneStr;
            }
            phoneRect = [PhoneLab boundingRectWithInitSize:PhoneLab.frame.size];
            PhoneLab.frame = CGRectMake(ScreenWidth - 30 - phoneRect.size.width, 9, phoneRect.size.width+ 10, 26);
            
            
        }else{
            if (isEnding) {
                UITextField *emailField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth - 160, 0, 140, 44)];
                emailField.placeholder = @"请输入邮箱";
                emailField.delegate = self;
                emailField.font = [UIFont systemFontOfSize:14];
                emailField.textColor = detailTextColor;
                emailField.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:emailField];
                
                if ([Utile stringIsNil:email]) {
                    
                }else{
                    emailField.text = email;
                }
            }else{
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 160, 0, 140, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                
                if ([Utile stringIsNil:email]) {
                    
                }else{
                    PhoneLab.text = email;
                }
            }
            
        }
    }else{
        if (indexPath.row == 0) {
            if (isEnding) {
                
                if ([yiyuanStyle isEqualToString:@"医院"]) {
                    UIImageView *yiiMG = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, 14, 15, 15)];
                    yiiMG.image = [UIImage imageNamed:@"搜索-搜索"];
                    [cell.contentView addSubview:yiiMG];
                    
                    UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth - 140, 44)];
                    PhoneLab.font = [UIFont systemFontOfSize:14];
                    PhoneLab.textColor = detailTextColor;
                    PhoneLab.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:PhoneLab];
                    
                    if ([Utile stringIsNil:hospitalName]&&[Utile stringIsNil:newHosptialName]) {
                        
                    }else{
                        PhoneLab.text = [NSString IsNullStr:newHosptialName]?hospitalName:newHosptialName;
                    }
                }else{
                    UITextField *hoeField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth - 120, 44)];
                    hoeField.font = [UIFont systemFontOfSize:14];
                    hoeField.delegate = self;
                    hoeField.textColor = detailTextColor;
                    hoeField.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:hoeField];
                    
                    if ([Utile stringIsNil:clinic]) {
                        
                    }else{
                        hoeField.text = clinic;
                    }
                }
                
                
                UIButton *hospitailBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
                [hospitailBtn addTarget:self action:@selector(didHospitalButton) forControlEvents:UIControlEventTouchUpInside];
                [hospitailBtn setImage:[UIImage imageNamed:@"箭头_下"] forState:normal];
                hospitailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
                [cell.contentView addSubview:hospitailBtn];

            }else{
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth - 120, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                
                if ([Utile stringIsNil:hospitalName]) {
                    
                }else{
                    PhoneLab.text = hospitalName;
                }
            }
        }else if (indexPath.row == 1){
            if (isEnding) {
                UIImageView *imga = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 33, 17, 13, 7)];
                imga.image = [UIImage imageNamed:@"箭头_下"];
                [cell.contentView addSubview:imga];
                
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 220, 0, 180, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                
                if ([yiyuanStyle isEqualToString:@"医院"]) {
                    
                }else{
                    deptName = @"";
                }
                
                if ([Utile stringIsNil:deptName]&&[Utile stringIsNil:newDeptName]) {
                    
                }else{
                    PhoneLab.text = [NSString IsNullStr:newDeptName]?deptName:newDeptName;
                }

            }else{
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 0, 80, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                
                if ([yiyuanStyle isEqualToString:@"医院"]) {
                    
                }else{
                    deptName = @"";
                }
                
                if ([Utile stringIsNil:deptName]) {
                    
                }else{
                    PhoneLab.text = deptName;
                }
            }
        }else if (indexPath.row == 2){
            if (isEnding) {
                UIImageView *imafe = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 33, 17, 13, 7)];
                imafe.image = [UIImage imageNamed:@"箭头_下"];
                [cell.contentView addSubview:imafe];
                
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 120, 0, 80, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                if ([Utile stringIsNil:titleName]) {
                    
                }else{
                    PhoneLab.text = titleName;
                }
            }else{
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 0, 80, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                if ([Utile stringIsNil:titleName]) {
                    
                }else{
                    PhoneLab.text = titleName;
                }
            }
        }else if (indexPath.row == 3){
            if (isEnding) {
                UITextField *numberField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, ScreenWidth-140, 44)];
                numberField.placeholder = @"请输入执业医师编号";
                numberField.delegate = self;
                numberField.font = [UIFont systemFontOfSize:14];
                numberField.textColor = detailTextColor;
                numberField.textAlignment = NSTextAlignmentRight;
                numberField.keyboardType = UIKeyboardTypeASCIICapable;
                [cell.contentView addSubview:numberField];
                
                if ([Utile stringIsNil:num]) {
                    
                }else{
                    numberField.text = num;
                }
            }else{
                
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, ScreenWidth-140, 44)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                if ([Utile stringIsNil:num]) {
                    
                }else{
                    PhoneLab.text = num;
                }
            }
        }else if (indexPath.row == 4){
            
            if (isEnding) {
                UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, 14, 9, 15)];
                jiantouImg.image = [UIImage imageNamed:@"ARROW---RIGHT"];
                [cell.contentView addSubview:jiantouImg];
               // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                
            }
            
            UIScrollView *scrol = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth - 120, 44)];
            
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewScrollowView)];
            [scrol addGestureRecognizer:tapGesture];
            scrol.delegate = self;
            [cell.contentView addSubview:scrol];
            
            for (int a = 0; a  < chaungchangArr.count; a ++) {
                UILabel *guanLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + 70 * a, 7, 60, 30)];
                guanLab.text = [NSString stringWithFormat:@"%@",chaungchangArr[a]];
                guanLab.textColor = detailTextColor;
                guanLab.backgroundColor = SetColor(0xf0f0f0);
                guanLab.layer.masksToBounds = YES;
                guanLab.layer.cornerRadius = 2;
                guanLab.font = [UIFont systemFontOfSize:14];
                guanLab.textAlignment = NSTextAlignmentCenter;
                [scrol addSubview:guanLab];
            }
            if (IS_IPHONE_5) {
                if (chaungchangArr.count > 3) {
                    scrol.frame = CGRectMake(100, 0, ScreenWidth - 120, 44);
                }else{
                    scrol.frame = CGRectMake(ScreenWidth - 25 - (60 + 20)* chaungchangArr.count + 20, 0, (60 + 20)* chaungchangArr.count - 20, 44);
                }
                scrol.contentSize = CGSizeMake((60 + 20)* chaungchangArr.count- 20,0);
                scrol.pagingEnabled = YES;

            }else{
                if (chaungchangArr.count > 4) {
                    scrol.frame = CGRectMake(100, 0, ScreenWidth - 120, 44);
                }else{
                    scrol.frame = CGRectMake(ScreenWidth - 25 - (60 + 20)* chaungchangArr.count + 20, 0, (60 + 20)* chaungchangArr.count - 20, 44);
                }
                scrol.contentSize = CGSizeMake((60 + 20)* chaungchangArr.count- 20,0);
                scrol.pagingEnabled = YES;

            }
            
            
        }else{
            
            
            if (isEnding) {
                
                
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 12,ScreenWidth - 140, 0)];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                PhoneLab.numberOfLines = 0;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                
                if ([Utile stringIsNil:content]) {
                    
                }else{
                    PhoneLab.text = content;
                }
                
                zhuanRect = [PhoneLab boundingRectWithInitSize:PhoneLab.frame.size];
                PhoneLab.frame = CGRectMake(100, 12, ScreenWidth - 140, zhuanRect.size.height);
                
                UIImageView *jiantouImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 30, (zhuanRect.size.height + 24)/2 - 8, 9, 15)];
                jiantouImg.image = [UIImage imageNamed:@"ARROW---RIGHT"];
                [cell.contentView addSubview:jiantouImg];
                
                
            }else{
                UILabel *PhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 12,ScreenWidth - 130,0 )];
                PhoneLab.font = [UIFont systemFontOfSize:14];
                PhoneLab.textColor = detailTextColor;
                
                PhoneLab.numberOfLines = 0;
                PhoneLab.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:PhoneLab];
                
                if ([Utile stringIsNil:content]) {
                    
                }else{
                    PhoneLab.text = content;
                }
                zhuanRect = [PhoneLab boundingRectWithInitSize:PhoneLab.frame.size];
                PhoneLab.frame = CGRectMake(100, 12, ScreenWidth - 130, zhuanRect.size.height + 24);
                
            }
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (isEnding) {
                [self makeChosePhoto];
            }else{
                
            }
            
        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            
            
        }else if (indexPath.row == 3) {
            if (isEnding) {
                [self didTimeButton];
            }else{
                
            }
        }else if (indexPath.row == 4){
        }else{
            
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            if (isEnding) {
                ChoseYiYuanViewController *change = [[ChoseYiYuanViewController alloc]initWithStyle:selectYiYuan];
                
                change.returnYuan = ^(NSDictionary *dica){
                    NSLog(@"%@",dica);
                    hospitalDic = dica;
                    hospitalName = [dica objectForKey:@"hospitalName"];
                    hospitalId = [NSString stringWithFormat:@"%@",[dica objectForKey:@"hospitalId"]];
                    [self makeAddChoseKeshi];
                    [mainTableview reloadData];
                };
                change.EditHospitalBlock = ^(NSString *hospitalStr, NSString *departStr) {
                    newHosptialName = hospitalStr;
                    newDeptName = departStr;
                    [mainTableview reloadData];
                };
                change.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:change animated:NO];
            }else{
                
            }

        }else if (indexPath.row == 1){
            if (isEnding) {
                
                if ([yiyuanStyle isEqualToString:@"医院"]) {
                    if (![NSString IsNullStr:newDeptName]) {
                        return;
                    }
                    dataStyle = @"2";
                    pickArr = keshiArr;
                    [mainPickView reloadAllComponents];
                    heiseView.hidden = NO;

                }else{
                    
                }
                
            }else{
                
            }
        }else if (indexPath.row == 2){
            if (isEnding) {
                dataStyle = @"3";
                pickArr = zhichengArr;
                [mainPickView reloadAllComponents];
                heiseView.hidden = NO;
            }else{
                
            }
        }else if (indexPath.row == 3){
            
        }else if (indexPath.row == 4) {
            if (isEnding) {
                ZhhuanChangViewController *change = [[ZhhuanChangViewController alloc]init];
                change.typeStr = @"2";
                if (publicArr.count == 0) {
                    change.selectArray = arrOne;
                }else{
                    change.selectArray  = publicArr;
                }
                
                change.returnChang = ^(NSMutableArray *arr){
                    NSLog(@"%@",arr);
                    publicArr = [NSArray arrayWithArray:arr];
                    NSMutableArray *oneArr = [NSMutableArray array];
                    NSMutableArray *twoArr = [NSMutableArray array];
                    for (NSDictionary *oneDic in arr) {
                        [oneArr addObject:[oneDic objectForKey:@"specialtyName"]];
                        [twoArr addObject:[oneDic objectForKey:@"uid"]];
                    }
                    
                    chaungchangArr = oneArr;
                    specialty = [twoArr componentsJoinedByString:@","];
                    [mainTableview reloadData];
                };
                change.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:change animated:NO];

            }else{
                
            }
        }else{
            if (isEnding) {
                ChangeGeRenInfoViewController *change = [[ChangeGeRenInfoViewController alloc]initWithStyle:selectjianjie];
                change.returnJIan = ^(NSString *contentStr){
                    NSLog(@"%@",contentStr);
                    content = contentStr;
                    [mainTableview reloadData];
                };
                
                change.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:change animated:NO];

            }else{
                
            }
        }
    }
    
}
- (void)didViewScrollowView{
    ZhhuanChangViewController *change = [[ZhhuanChangViewController alloc]init];
    change.typeStr = @"2";
    if (publicArr.count == 0) {
        change.selectArray = arrOne;
    }else{
        change.selectArray  = publicArr;
    }
    
    change.returnChang = ^(NSMutableArray *arr){
        NSLog(@"%@",arr);
        publicArr = [NSArray arrayWithArray:arr];
        NSMutableArray *oneArr = [NSMutableArray array];
        NSMutableArray *twoArr = [NSMutableArray array];
        for (NSDictionary *oneDic in arr) {
            [oneArr addObject:[oneDic objectForKey:@"specialtyName"]];
            [twoArr addObject:[oneDic objectForKey:@"uid"]];
        }
        
        chaungchangArr = oneArr;
        specialty = [twoArr componentsJoinedByString:@","];
        [mainTableview reloadData];
    };
    change.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:change animated:NO];

}
#pragma mark  选择医院，科室
- (void)didHospitalButton{
    heiseView.hidden = NO;
    dataStyle = @"1";
    pickArr = yiyuanArr;
    [mainPickView reloadAllComponents];
    
}
#pragma mark  选择照片
- (void)makeChosePhoto{
    if(_pikerView==nil){
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
    [imgArr removeAllObjects];
    [imgNames removeAllObjects];
    
    //start
    ZYQAssetPickerController *pick = [[ZYQAssetPickerController alloc]init];
    pick.maximumNumberOfSelection = 1 - imgArr.count;
    pick.assetsFilter = [ALAssetsFilter allPhotos];
    pick.delegate = self;
    pick.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id  evaluatedObject, NSDictionary*  bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 1;
        }else{
            return YES;
        }
    }];
    
    
    [self presentViewController:pick animated:YES completion:NULL];
    //end
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [self.ChoseView removeFromSuperview];
        self.ChoseView = nil;
    }];
}

#pragma 头像 拍照按钮
- (void)makeSelectBtnTwo{
    [imgArr removeAllObjects];
    [imgNames removeAllObjects];
    
    //start
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
        
    }
    
    imgPicker.delegate = self;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];

    //end
    
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
#pragma mark - ZYQAssetPickerColltroller delegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i = 0; i < assets.count; i ++) {
        ALAsset *asset = assets[i];
        UIImage *img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSString *imgName = asset.defaultRepresentation.filename;
        [imgArr addObject:img];
        [imgNames addObject:imgName];
        
    }
    [mainTableview reloadData];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *imgage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [imgArr addObject:imgage];
    
    [mainTableview reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];//用时间给文件命名
        [formate setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_%@.png", [formate stringFromDate:[NSDate date]]]];
        
        NSData *data = UIImageJPEGRepresentation(imgage, proportion);
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
        [imgNames addObject:filePath];
        
    }];
    
}

- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
}


#pragma mark 性别按钮点击
- (void)didXingBieButton:(UIButton *)sender{
    sender.selected  =! sender.selected;
    if (sender != self.selectBtn) {
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
    }else{
        self.selectBtn.selected = YES;
    }
    
    if (sender.tag ==100) {
        gender = [NSString stringWithFormat:@"1"];
    }else{
        gender = [NSString stringWithFormat:@"0"];
    }
    
}


// keshi end
#pragma mark 随访时间 start time
- (void)didTimeButton{
    if(_pikerView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        
        [self.view addSubview:_backWindowView];
        _pikerView = [DatePickerView datePickerView];
        _pikerView.delegate = self;
        _pikerView.type = 0;
        _pikerView.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        [self.view addSubview:_pikerView];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _pikerView.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _pikerView.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
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
    birth = [NSString stringWithFormat:@"%@", date];
    NSLog(@"%@",birth);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.pikerView removeFromSuperview];
        self.pikerView = nil;
    }];
    [mainTableview reloadData];
}
- (BOOL)stringIsgenerNil:(NSString *)strings{
    if ([strings isEqualToString:@""]||[strings isEqualToString:@"(null)"]||[strings isEqualToString:@"<null>"]||(strings.length == 0)||[strings isEqualToString:@"空字符"]) {
        return YES;
    }else{
        return NO;
    }
    
}

// time end
#pragma mark 提交按钮
- (void)didTiJiaoButton{
    if ((imgArr.count == 0)&&[Utile stringIsNil:portrait]) {
        [self showHint:@"请选择头像"];
        return;
    }else if(imgArr.count > 0){
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
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                NSArray *array = [NSArray arrayWithArray:data[@"data"]];
                portrait = [array componentsJoinedByString:@","];

                [self tijiaoInfo];
            }else{
                [self showHint:data[@"message"]];
            }
            
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"%@",error);
        }];
        
        
    }else{
        [self tijiaoInfo];
        
    }
}
- (void)tijiaoInfo{
    
//    if ([Utile stringIsNilZero:deptId]||[Utile stringIsNilZero:doctorName]||[Utile stringIsNilZero:gender]) {
//        return;
//    }
    
    if ([yiyuanStyle isEqualToString:@"医院"]) {
        if ([Utile stringIsNilZero:doctorName]||[Utile stringIsNilZero:gender]) {
            return;
        }
        if(newDeptName){
            
        }else if ([NSString IsNullStr:deptId]&&[NSString IsNullStr:newDeptName]) {
            [self showHint:@"请选择科室"];
            return ;
        }

        
        clinic = @"";
    }else{
        if ([Utile stringIsNilZero:doctorName]||[Utile stringIsNilZero:gender]) {
            return;
        }
        deptId = @"";
        hospitalName = @"";
        hospitalId = @"";
        newDeptName = @"";
        newHosptialName = @"";
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorsave];
    NSArray *keysArray = @[@"sessionid",@"doctorName",@"gender",@"birth",@"email",@"hospitalId",@"clinic",@"deptId",@"titleId",@"num",@"content",@"portrait",@"specialty",@"newHosptialName",@"newDeptName"];
    NSArray *valueArray = @[sessionIding,doctorName,gender,birth,email,hospitalId,clinic,deptId,titleId,num,content,portrait,specialty,newHosptialName,newDeptName];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
//            isEnding = NO;
            [mainTableview reloadData];
//            [self makeDataZhanshi];
            if (self.submitInfoSucess) {
                self.submitInfoSucess();
            }
            [self.navigationController popViewControllerAnimated:NO];
            
        }else{
            
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];

}

#pragma mark filed delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)[textField superview].superview;
    NSIndexPath *indexpath = [mainTableview indexPathForCell:cell];
    if (indexpath.section == 0) {
        if (indexpath.row == 1) {
            doctorName = textField.text;
        }else if(indexpath.row == 5){
            email = textField.text;
        }
    }else{
        if (indexpath.row == 0) {
            clinic = textField.text;
        }else if(indexpath.row == 3){
            num = textField.text;
        }
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
