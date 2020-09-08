//
//  ZJNChangePatientBasicInfoViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangePatientBasicInfoViewController.h"
#import "ZJNTextFieldTableViewCell.h"
#import "ZJNArrowTableViewCell.h"
#import "ZJNSingleSelectTableViewCell.h"
#import "ZJNChoosePicturesTableViewCell.h"
#import "PhotoChoseView.h"
#import "MWPhotoBrowser.h"
#import "ZYQAssetPickerController.h"
#import "DatePickerView.h"
#import "ZJNPatientBodyInfoViewController.h"
#import "ZJNTitleAndTextViewTableViewCell.h"
#import "TZImagePickerController.h"
#import "ZJNMRSharesTableViewCell.h"
#import "ZJNMRShareDoctorViewController.h"
#define kPadding 10
#define imageWidth (ScreenWidth-50)/4.0

#import "QJSelectArea.h"

@interface ZJNChangePatientBasicInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNChoosePCellDelegate,ChoseViewDelegate,MWPhotoBrowserDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,ZJNSingleSelectDelegate,DatePickerViewDelegate,ZJNTitleAndTextViewTableViewDelegate,TZImagePickerControllerDelegate,ZJNMRSharesTableViewCellDelegate,ZJNMRShareDoctorViewControllerDelegate>
{
    QJSelectArea  * selectAreaPick ;

    UITableView *_tableView;
    NSArray *titleArr;
    NSArray *placeHolderArr;
    PhotoChoseView *_ChoseView;
    UIView  *_backWindowView;
    MWPhotoBrowser *browser;
    UIImagePickerController *imgPicker;
    DatePickerView *_DatePick;
    NSArray *relationArr;//联系人关系数组
    NSArray *nationArr;//民族数组
    NSArray *doctorArr;//分享医生数组
    
    NSString *styleTime;//1 患者入院时间 ；0 患者出院时间
    NSString *patientNation;//患者民族(只用来显示)
    NSString *linkmanRelation;//与本人关系(只用来显示)
    NSMutableArray  *imageArr;//上传图片集合
    CGFloat textViewCellHeight;//患者家庭住址单元格高度
    NSArray * AreaDataArray;// 所有省市数据；

}

//@property (nonatomic, strong) UIButton *naviRightButton;

@end

@implementation ZJNChangePatientBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者基本信息";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
    
    [self initPatientInfo];
    titleArr = @[@[@"姓名",@"性别",@"民族",@"年龄",@"住院号"],@[],@[@"联系人",@"与本人关系",@"联系方式"],@[@"省市区",@"详细住址",@"身份证号码",@"入院时间",@"出院时间"],@[@""]];
    
    placeHolderArr = @[@[@"请输入患者姓名",@"",@"请选择患者民族",@"请输入患者年龄",@"请输入患者住院号"],@[],@[@"请输入患者联系人姓名",@"请选择患者与联系人关系",@"请输入联系方式"],@[@"请选择患者家庭省市区",@"请输入患者家庭详细住址",@"请输入患者身份证号码",@"请选择患者入院时间",@"请选择患者出院时间"]];
    
    doctorArr = self.infoModel.share;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    /*
    if (self.isfromPatientMsg) {
        [self getData];
    }
    */
    [ self makeAllAreaData];
    // Do any additional setup after loading the view.
}

/*
- (UIButton *)naviRightButton
{
    if (!_naviRightButton) {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_naviRightButton setImage:[UIImage imageNamed:@"MORE"] forState:UIControlStateNormal];
        [_naviRightButton addTarget:self action:@selector(naviRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _naviRightButton;
}

- (void)naviRightButtonAction
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"患者编辑的基本信息" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"归档" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self checkIfSave:YES];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"打回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkIfSave:NO];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark 归档或打回
- (void)checkIfSave:(BOOL)save
{
    [self showHudInView:self.view hint:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_info_archive];
    NSDictionary *para = @{
        @"sessionid":self.infoModel.sessionId,
        @"hospnumId":self.infoModel.hospnumId,
        @"archive": save ? @(1).stringValue : @(2).stringValue
    };
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        [self hideHud];
        NSLog(@"---患者基本信息归档--data:%@",data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            [self showHint:@"患者基本信息归档成功" inView:self.view];
        }else{
            [self showHint:dict[@"message"] inView:self.view];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"---患者基本信息归档--error:%@", error);
    }];
}
 */

/*
- (void)getData
{
    if (!self.infoModel.sessionId.isValidStringValue) {
        NSLog(@"---患者基本信息--data:%@",@"sessionId不能为空");
        return;
    }
    
    if (!self.infoModel.hospnumId.isValidStringValue) {
        NSLog(@"---患者基本信息--data:%@",@"hospnumId不能为空");
        return;
    }
    
    [self showHudInView:self.view hint:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patient_modify_info];
    NSDictionary *para = @{@"sessionid":self.infoModel.sessionId, @"hospnumId":self.infoModel.hospnumId};
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        [self hideHud];
        NSLog(@"---患者基本信息--data:%@",data);
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] intValue] == 0) {
            ZJNChangePatientBasicInfoModel *model = [ZJNChangePatientBasicInfoModel mj_objectWithKeyValues:dict[@"data"]];
            model.sessionId = self.infoModel.sessionId;
            model.hospnumId = self.infoModel.hospnumId;
            long age = (long)dict[@"data"][@"brith"];
            if (age > 0) {
                model.birth = @(age).stringValue;
            }
            self.infoModel = model;
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"---患者基本信息--error:%@", error);
    }];
}
*/
#pragma mark  民族
- (void)requestNationFromServer{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,nationlist];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"民族%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            nationArr = [NSArray arrayWithArray:data[@"data"]];
            [self showActionSheetWithArray:nationArr withType:@"nation"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"民族%@",error);
    }];
}
#pragma mark 与本人关系列表
- (void)requestRelationFromServer{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,relationlist];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"与本人关系%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            relationArr = [NSArray arrayWithArray:data[@"data"]];
            [self showActionSheetWithArray:relationArr withType:@"relation"];
        }else{
            
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"与本人关系%@",error);
    }];
    
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if (section == 2){
        return 3;
    }else if (section == 3){
        return 5;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        NSInteger y;
        NSInteger x;
        if (imageArr.count<16) {
            y = (imageArr.count+1)/4;
            x = (imageArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (imageArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else if (indexPath.section == 3&& indexPath.row == 0){
        return MAX(44, textViewCellHeight);
    }else if (indexPath.section == 1){
        
        NSInteger a = doctorArr.count/6;
        NSInteger b = doctorArr.count%6;
        if (b>0||a == 0) {
            a += 1;
        }
        return a *((ScreenWidth-70)/6.0+30+10)+10;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 140;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
    greenImg.image = [UIImage imageNamed:@"矩形-6"];
    [heardView addSubview:greenImg];
    
    UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 0, 80, 44)];
    titlLab.font = Font14;
    titlLab.textColor = SetColor(0x1a1a1a);
    [heardView addSubview:titlLab];
    
    if (section == 0) {
        titlLab.text = @"基本资料";
    }else if (section == 1){
        titlLab.text = @"病例共享者";
    }else if (section == 2){
        titlLab.text = @"联系人信息";
    }else if (section == 3){
        titlLab.text = @"详细信息";
    }else{
        titlLab.text = @"上传图片";
        
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlLab.frame)+ 5, 15, 18, 16)];
        images.image = [UIImage imageNamed:@"上传图片123"];
        [heardView addSubview:images];
    }
    return heardView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
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
    }else{
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0&&indexPath.row ==2)||(indexPath.section == 2&&indexPath.row ==1)) {
        static NSString *cellid = @"cellid";
        ZJNArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNArrowTableViewCell" owner:self options:nil]lastObject];
        }
        NSString *contentStr;
        if (indexPath.section == 0&&indexPath.row ==2) {
            contentStr = patientNation;
        }else{
            contentStr = linkmanRelation;
        }
        
        if (contentStr.length) {
            cell.contentLabel.text = contentStr;
        }else{
            cell.contentLabel.textColor = SetColor(0x666666);
            cell.contentLabel.text = placeHolderArr[indexPath.section][indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 0&&indexPath.row == 1){
        static NSString *cellid = @"cellId";
        ZJNSingleSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNSingleSelectTableViewCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        if ([_infoModel.gender isEqualToString:@"0"]) {
            cell.rightButton.selected = YES;
        }else if ([_infoModel.gender isEqualToString:@"1"]){
            cell.leftButton.selected = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ((indexPath.section == 3&&indexPath.row == 0)||(indexPath.section == 3&&indexPath.row == 1)){
        static NSString *cellid = @"zceLLID";
//        ZJNTitleAndTextViewTableViewCell *cell = [tableView expandableTitleAndTextViewTextCellWithId:cellid];
//
//        cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
//        cell.textView.placeholder = placeHolderArr[indexPath.section][indexPath.row];
//        cell.textView.textAlignment = NSTextAlignmentRight;
//        if (indexPath.row == 0) {
//            cell.text = _infoModel.area;
//            cell.EndBlock = ^(NSString *textViewText) {
//                [self makeAddressDetail:textViewText];
//            };
//        }else{
//            cell.text = _infoModel.homeAdress;
//        }
        ZJNTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNTextFieldTableViewCell" owner:self options:nil]lastObject];
        }
        cell.textField.delegate = self;
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
        cell.textField.placeholder = placeHolderArr[indexPath.section][indexPath.row];
        cell.textField.textAlignment = NSTextAlignmentRight;
        if(indexPath.row == 0){
            cell.textField.userInteractionEnabled = NO ;
            cell.textField.text = [NSString changeNullString:_infoModel.area];
         }else{
            cell.textField.text = _infoModel.homeAdress;
            
        }
        
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellid = @"shareCell";
        ZJNMRSharesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNMRSharesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellType:ZJNMRSharesTableViewCellEditing];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.dataArray = doctorArr;
        return cell;
    }else if (indexPath.section == 4){
        
        static NSString *cellid = @"cellID";
        ZJNChoosePicturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNChoosePicturesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageArray = imageArr;
        return cell;
    }else{
        static NSString *cellid = @"celLID";
        ZJNTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNTextFieldTableViewCell" owner:self options:nil]lastObject];
        }
        cell.textField.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
        cell.textField.placeholder = placeHolderArr[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textField.text = _infoModel.patientName;
            }else if (indexPath.row == 3){
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = _infoModel.birth;
            }else if (indexPath.row == 4){
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = _infoModel.hospNum;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                cell.textField.text = _infoModel.linkman;
            }else if (indexPath.row == 2){
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = _infoModel.phone;
            }
        }else{
            
            if (indexPath.row == 0) {
                cell.textField.text = _infoModel.area;
            }else if (indexPath.row == 1) {
                cell.textField.text = _infoModel.homeAdress;
            }else  if (indexPath.row == 2){
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.textField.text = _infoModel.idCard;
            }else if (indexPath.row == 3){
                cell.textField.userInteractionEnabled = NO;
                cell.textField.text = _infoModel.inTime;
            }else{
                cell.textField.userInteractionEnabled = NO;
                cell.textField.text = _infoModel.outTime;
            }
        }
        
        return cell;
    }
}
//获取地址信息
-(void)makeAddressDetail:(NSString *)Address{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,GetAddressWithadd];
    NSArray *keysArray = @[@"sessionid",@"addressName"];
    NSArray *valueArray = @[sessionIding,Address];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        
        if ([retcode isEqualToString:@"0000"]) {
            self.infoModel.area = data[@"data"][@"formattedAddress"];
        }else{
            self.infoModel.area = @"";
            [self showHint:data[@"message"]];
        }
        [_tableView reloadData];
        
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        self.infoModel.homeAdress = @"";
        [self showHint:@"暂时无法获取地址信息"];
        [_tableView reloadData];
        
        
        
    }];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self requestNationFromServer];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [self requestRelationFromServer];
    }else if (indexPath.section == 3){
        if (indexPath.row == 3) {
            styleTime = @"1";
            [self didTimeButton];
        }else if (indexPath.row == 4){
            styleTime = @"0";
            [self didTimeButton];
        }else if( indexPath.row == 0){
      
        if(AreaDataArray){
            selectAreaPick =[[QJSelectArea alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 250)];
            [self.view addSubview:selectAreaPick];
            [selectAreaPick makeDatawithArray:AreaDataArray];
            [selectAreaPick ShowAreaPicker];
            __block  UITableView * WeakTv = tableView;
            __block typeof(_infoModel) blockModel = _infoModel;
            selectAreaPick.CertainBlock = ^(BOOL IsCertain, NSString *dateString, NSString *prvId, NSString *cityId, NSString *AreaId) {
                if (IsCertain) {
                    blockModel.area = dateString;
                    blockModel.provinceId = prvId;
                    blockModel.cityId = cityId;
                    blockModel.districtId = AreaId;
                    [WeakTv reloadData];
                }else{
                    
                }
            };
        }

    }
        
    }
}
#pragma mark--ZJNTitleAndTextViewTableViewDelegate
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3  && indexPath.row == 0){
        _infoModel.area = text;
    }else  if(indexPath.section == 3  && indexPath.row == 1){
        _infoModel.homeAdress = text;
    }

    
}
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath{
    textViewCellHeight = height;
}
-(void)showActionSheetWithArray:(NSArray *)array withType:(NSString *)type{
    ZJNArrowTableViewCell *cell;
    if ([type isEqualToString:@"nation"]) {
        cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    }else{
        cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i <array.count; i ++) {
        NSDictionary *dic = array[i];
        NSString *title;
        if ([type isEqualToString:@"nation"]) {
            title = dic[@"nationName"];
        }else{
            title = dic[@"relationName"];
        }
        UIAlertAction *firstAct = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([type isEqualToString:@"nation"]) {
                patientNation = title;
                _infoModel.national = dic[@"national"];
            }else{
                linkmanRelation = title;
                _infoModel.relationid = dic[@"relation"];
                _infoModel.relation = dic[@"relationName"];
             }
            [_tableView reloadData];
        }];
        [alert addAction:firstAct];
        [firstAct setValue:greenC forKey:@"_titleTextColor"];
    }
    
    UIAlertAction *thirdAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:thirdAct];
    
    [thirdAct setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    if (array.count >5) {
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:350];
        [alert.view addConstraint:height];
    }
    if([ZJNDeviceInfo deviceIsPhone]){
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        popPresenter.sourceView = cell; // 这就是挂靠的对象
        popPresenter.sourceRect = cell.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark--ZJNChoosePCellDelegate
/*
 * 添加图片
 */
-(void)choosePicturesTableViewCellAddPicturesWithCell:(ZJNChoosePicturesTableViewCell *)cell{
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
            [_ChoseView removeFromSuperview];
            _ChoseView = nil;
        }];
    }
}
/*
 * 预览图片
 */
-(void)choosePicturesTableViewCellPreviewPictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell{
    browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    browser.hidesBottomBarWhenPushed = YES;
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:NO];
}
/*
 * 删除图片
 */
-(void)choosePicturesTableViewCellDeletePictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell{
    [imageArr removeObjectAtIndex:index];
    [_tableView reloadData];
}
#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return imageArr.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    NSString * photimageStr  =[NSString stringWithFormat:@"%@",imageArr[index]];
    if ([photimageStr containsString:imgPath]) {
    }else{
        photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];

    }
    photimageStr = [photimageStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"imgs"];

    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
    

    return photot;
}
#pragma mark--ChoseViewDelegate
// 从系统相册选择按钮

-(void)makeSelectBtnOne{
    TZImagePickerController *tzController = [[TZImagePickerController alloc]initWithMaxImagesCount:16-imageArr.count delegate:self];
    tzController.allowPreview = YES;
    tzController.allowPickingVideo = NO;
    tzController.allowPickingGif = NO;
    tzController.allowPickingOriginalPhoto = NO;
    [tzController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSMutableArray *publicArr = [NSMutableArray array];
        
        [publicArr addObjectsFromArray:photos];
        
        NSMutableArray *publicStringArr = [NSMutableArray array];
        
        for (int i = 0; i <publicArr.count; i ++) {
            NSData *data = UIImageJPEGRepresentation([Utile fixOrientation:publicArr[i]], proportion);
            NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [publicStringArr addObject:imageString];
        }
        NSString *path = [publicStringArr componentsJoinedByString:@","];
        [self postImageToServerWithPath:path];
        
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
// 拍照按钮
- (void)makeSelectBtnTwo{
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
        
    }
    
    imgPicker.delegate = self;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [_ChoseView removeFromSuperview];
        _ChoseView = nil;
    }];
    
}
#pragma mark - ZYQAssetPickerColltroller delegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i = 0; i < assets.count; i ++) {
        ALAsset *asset = assets[i];
        UIImage *img = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSMutableArray *publicArr = [NSMutableArray array];
        [publicArr addObject:img];
        
        NSMutableArray *publicStringArr = [NSMutableArray array];
        
        for (int i = 0; i <publicArr.count; i ++) {
            NSData *data = UIImageJPEGRepresentation([Utile fixOrientation:publicArr[i]], proportion);
            NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            [publicStringArr addObject:imageString];
        }
        NSString *path = [publicStringArr componentsJoinedByString:@","];
        [self postImageToServerWithPath:path];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *imgage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSMutableArray *arraypublic = [NSMutableArray array];
    [arraypublic addObject:imgage];
    
    NSMutableArray *publicStringArr = [NSMutableArray array];
    //
    for (int i = 0; i <arraypublic.count; i ++) {
        NSData *data = UIImageJPEGRepresentation([Utile fixOrientation:arraypublic[i]], proportion);
        NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [publicStringArr addObject:imageString];
    }
    NSString *path = [publicStringArr componentsJoinedByString:@","];
    [self postImageToServerWithPath:path];
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    
}
-(void)postImageToServerWithPath:(NSString *)path{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,uploadimageUpload];
    NSArray *keysArray = @[@"fromFile"];
    NSArray *valueArray = @[path];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [imageArr addObjectsFromArray:data[@"data"]];
        }
        [_tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self hideHud];
    }];
}
- (void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    NSLog(@"到达上限");
}
// 取消按钮
- (void)makeSelectBtnThree{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _ChoseView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 160);
    } completion:^(BOOL finished) {
        [_ChoseView removeFromSuperview];
        _ChoseView = nil;
    }];
    
}
#pragma mark--ZJNSingleSelectDelegate
-(void)singleSelectedWithType:(NSString *)type{
    _infoModel.gender = type;
}
#pragma mark--UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    ZJNTextFieldTableViewCell *cell = (ZJNTextFieldTableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _infoModel.patientName = textField.text;
        }else if (indexPath.row == 3){
            _infoModel.birth = textField.text;
        }else if (indexPath.row == 4){
            _infoModel.hospNum = textField.text;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            _infoModel.linkman = textField.text;
        }else if (indexPath.row == 2){
            _infoModel.phone = textField.text;
        }
    }else{
        if (indexPath.row == 0) {
            _infoModel.homeAdress = textField.text;
        }else if (indexPath.row == 1){
            _infoModel.idCard = textField.text;
        }else if (indexPath.row == 2){
            _infoModel.inTime = textField.text;
        }else{
            _infoModel.outTime = textField.text;
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
#pragma mark 开始时间
- (void)didTimeButton{
    if(_DatePick==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        
        [self.view addSubview:_backWindowView];
        _DatePick = [DatePickerView datePickerView];
        if ([styleTime isEqualToString:@"1"]) {
            if (_infoModel.inTime.length>0) {
                _DatePick.datePickerView.date = [NSDate date:_infoModel.inTime WithFormat:@"yyyy-MM-dd"];
            }
        }else if ([styleTime isEqualToString:@"2"]){
            if (_infoModel.outTime.length>0) {
                _DatePick.datePickerView.date = [NSDate date:_infoModel.outTime WithFormat:@"yyyy-MM-dd"];
            }
        }
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
        [_DatePick removeFromSuperview];
        _DatePick = nil;
    }];
    
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    if ([styleTime isEqualToString:@"1"]) {
        _infoModel.inTime = [NSString stringWithFormat:@"%@", date];
    }else if([styleTime isEqualToString:@"0"]){
        _infoModel.outTime =  [NSString stringWithFormat:@"%@", date];
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [_DatePick removeFromSuperview];
        _DatePick = nil;
    }];
    
    [_tableView reloadData];
}
#pragma mark--选择分享医生
-(void)deleteSharesDoctorWithArray:(NSArray *)newDoctorArr{
    doctorArr = newDoctorArr;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)zjnMRSharesTableViewaddSharesDoctor{
    ZJNMRShareDoctorViewController *viewC = [[ZJNMRShareDoctorViewController alloc]init];
    viewC.delegate = self;
    viewC.dataArr = doctorArr;
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:YES];
}
-(void)shareDoctorWithArray:(NSArray *)array{
    doctorArr = array;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark--跳转到下级页面
-(void)nextButtonClick:(UIButton *)button{
    
    NSString *imageStr;
    if (imageArr.count == 0) {
        imageStr = @"";
    }else{
        imageStr = [imageArr componentsJoinedByString:@","];
     imageStr =   [imageStr stringByReplacingOccurrencesOfString:imgPath withString:@""];
    }
    //_infoModel.jbxx = imageStr;
    
    NSMutableArray *doctorUidArr = [NSMutableArray array];
    for (NSDictionary *dic in doctorArr) {
        [doctorUidArr addObject:dic[@"uid"]];
    }
    if (!self.infoModel.provinceId){
        [self showHint:@"请选择省市区"];
    }
    NSString *shareStr = [doctorUidArr componentsJoinedByString:@","];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,updatejbxx];
    NSArray *keysArr = @[@"sessionId",@"hospnumId",@"patientName",@"gender",@"birth",@"national",@"linkman",@"relation",@"phone",@"homeAdress",@"idCard",@"share",@"hospNum",@"inTime",@"outTime",@"jbxx",@"provinceId",@"cityId",@"districtId"];
    NSArray *valuesArr = @[self.infoModel.sessionId,self.infoModel.hospnumId,self.infoModel.patientName,self.infoModel.gender,self.infoModel.birth,self.infoModel.national,self.infoModel.linkman,self.infoModel.relationid,self.infoModel.phone,self.infoModel.homeAdress,self.infoModel.idCard,shareStr,self.infoModel.hospNum,self.infoModel.inTime,self.infoModel.outTime,imageStr,self.infoModel.provinceId,self.infoModel.cityId,self.infoModel.districtId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            if (self.refershPatientInfo) {
                self.refershPatientInfo();
            }
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:@"修改失败"];
        [self hideHud];
    }];
    
}
-(void)initPatientInfo{
    
    patientNation = self.infoModel.national;
    linkmanRelation = self.infoModel.relation;
    textViewCellHeight = 0;
    doctorArr = [NSArray array];
    imageArr = [NSMutableArray array];
    
    for (int a = 0; a < self.infoModel.jbxx.count; a ++ ) {
        NSString *imgPathstr = [NSString stringWithFormat:@"%@%@",imgPath,self.infoModel.jbxx[a][@"path"] ];
        [imageArr addObject:imgPathstr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeAllAreaData{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,allArea];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            
            AreaDataArray =[NSArray arrayWithArray:data[@"data"]];
            
            
        }else{
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"dizhi %@",error);
    }];
    
    
    
    //    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lot" ofType:@"plist"]];
    
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
