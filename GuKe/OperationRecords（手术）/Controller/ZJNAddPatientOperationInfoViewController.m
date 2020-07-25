//
//  ZJNAddPatientOperationInfoViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/5.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNAddPatientOperationInfoViewController.h"
#import "ZJNSelectGenderTableViewCell.h"
#import "ZJNTitleAndInfoTableViewCell.h"
#import "ZJNTitleAndTextfieldTableViewCell.h"
#import "ZJNAddOperationRequestModel.h"
#import "ZJNChoosePicturesTableViewCell.h"
#import "ZJNAnesthesiaTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "DatePickerView.h"
#import "ZJNAnesthesiaView.h"
#import "ZJNArrowTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "uploadModel.h"

#import "QJCAddBrandViewController.h"
#define kPadding 10
#define imageWidth (ScreenWidth-50)/4.0

#define VIDEOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoCache"]

@interface ZJNAddPatientOperationInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNChoosePCellDelegate,MWPhotoBrowserDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DatePickerViewDelegate,ZJNAnesthesiaTableViewCellDelegate>{
    NSArray *titleArr;
//    器械
    NSMutableArray *qxImageArr;
    NSMutableArray *qxImagePathArr;
//    X光片
    NSMutableArray *xImageArr;
    NSMutableArray *xImagePathArr;
//   术后视频
    NSMutableArray *SHArr;//步态视频上传后返回的地址（需要再传给服务器）
    NSMutableArray *SHImageArr;//步态视频上传后获取视频第一帧图片（用于展示）

    NSString * shuShiPinStr;
    NSMutableArray * uploadArray ;// 存放步态视频的地址；
    
//   术后体位
    NSMutableArray *SImageArr;
    NSMutableArray *SImagePathArr;
    
    
    NSArray *list1;
    NSArray *listjm;
    
    UIImagePickerController *imgPicker;
    
    NSArray *placeHolderArr;
    NSIndexPath *signIndexPath;
    MWPhotoBrowser *browser;
    
    UIView *_backWindowView;
    NSString * anestheName  ;// 选中的麻醉方式
    NSString  * patientSurgerType;//选中的类型
    NSString  * patientSurgerId;//选中的类型id

     NSInteger judge;//选择局麻的话可以点击向下的箭头选择更多
     NSMutableArray  * chaungchangArr ;// 选中的品牌
    NSMutableArray * showsurgeryTypeArray ;// 手术类别数组
}
@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)DatePickerView *DatePick;
@property (nonatomic ,strong)ZJNAnesthesiaView *anesthesiaView;
@end

@implementation ZJNAddPatientOperationInfoViewController

- (void)viewDidLoad {
//    添加手术记录
    [super viewDidLoad];
    self.title = @"手术情况";
    anestheName = @"请选择";

    self.view.backgroundColor = [UIColor whiteColor];
    judge = 0;
    qxImageArr = [NSMutableArray array];
    qxImagePathArr = [NSMutableArray array];
    SImageArr =[[NSMutableArray alloc]init];
    xImageArr  = [NSMutableArray array];
    xImagePathArr = [NSMutableArray array];
    SImagePathArr =[[NSMutableArray alloc]init];
    chaungchangArr =[[NSMutableArray alloc]init];
    _requestModel = [[ZJNAddOperationRequestModel alloc]init];
    showsurgeryTypeArray  =[[NSMutableArray alloc] init];
    _requestModel.sessionid = sessionIding;
    uploadArray =[[NSMutableArray alloc]init];
    SHArr =[[NSMutableArray alloc] init];
    SHImageArr =[[NSMutableArray alloc]init];
//    [self makeZhuJian];
    
    titleArr = @[@[@"姓名",@"性别",@"年龄",@"住院号"],@[@"手术日期",@"手术名称",@"手术入路",@"手术医生",@"第一助手",@"第二助手",@"手术类别"]];
    placeHolderArr = @[@"请选择手术时间",@"请输入手术名称",@"请输入手术入路",@"请输入手术医生",@"请输入第一助手",@"请输入第二助手",@"请选择手术分类"];
    
    [self makeMaZuiData];
    [self requestNationFromServer];// 获取手术类别
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-TabbarAddHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(ZJNAnesthesiaView *)anesthesiaView{
    if (!_anesthesiaView) {
        _anesthesiaView = [[ZJNAnesthesiaView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _anesthesiaView.dataArr = listjm;
        __weak typeof(self)weakSelf = self;
        _anesthesiaView.selectedAnesthesia = ^(NSString *anesthesiaName, NSString *anesthesiaUid) {
            weakSelf.requestModel.anesthesiaId = anesthesiaUid;
            anestheName = anesthesiaName ;
            [self.tableView reloadData];

        };
    }
    return _anesthesiaView;
}
#pragma mark 麻醉类型
- (void)makeMaZuiData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,anesthesialist];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
        NSLog(@"麻醉类型%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            list1 = data[@"data"][@"list1"];
            listjm = data[@"data"][@"listjm"];

            self.requestModel.anesthesiaId = list1[0][@"uid"];
            [self.view addSubview:self.tableView];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"麻醉类型%@",error);
        [self hideHud];
        
    }];
    
}
#pragma mark  手术类别
- (void)requestNationFromServer{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientsurgeryAllType];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"手术类别%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            showsurgeryTypeArray = [NSMutableArray  arrayWithArray:data[@"data"]];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"手术类别%@",error);
    }];
}
#pragma mark 手术信息显示
-(void)showActionSheetWithArray:(NSArray *)array withType:(NSString *)type{
    ZJNTitleAndTextfieldTableViewCell *cell;
         cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
     
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i <array.count; i ++) {
        NSDictionary *dic = array[i];
        NSString *title;
             title = dic[@"typeName"];
        
        UIAlertAction *firstAct = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if ([type isEqualToString:@"nation"]) {
                patientSurgerType = title;
                patientSurgerId  = dic[@"id"];
//                _infoModel.national = dic[@"national"];
//            }else{
//                linkmanRelation = title;
//                _infoModel.relation = dic[@"relation"];
//            }
            
            self.requestModel.surgeryType = [NSString stringWithFormat:@"%@", patientSurgerId];
            ZJNTitleAndTextfieldTableViewCell *cell = (ZJNTitleAndTextfieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
            cell.textField.text = patientSurgerType;
            
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


#pragma mark--<UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
//    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 7;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 7) {
        return 140;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 120;
    }else if (indexPath.section == 4){
        NSInteger y;
        NSInteger x;
        if (qxImageArr.count<16) {
            y = (qxImageArr.count+1)/4;
            x = (qxImageArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (qxImageArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else if (indexPath.section == 5){
        NSInteger y;
        NSInteger x;
        if (xImageArr.count<16) {
            y = (xImageArr.count+1)/4;
            x = (xImageArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (xImageArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else if (indexPath.section == 6){
        NSInteger y;
        NSInteger x;
        if (SHImageArr.count<16) {
            y = (SHImageArr.count+1)/4;
            x = (SHImageArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (SHImageArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else if (indexPath.section == 7){
        NSInteger y;
        NSInteger x;
        if (xImageArr.count<16) {
            y = (xImageArr.count+1)/4;
            x = (xImageArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (xImageArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else{
        return 44;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
    greenImg.image = [UIImage imageNamed:@"矩形-6"];
    [heardView addSubview:greenImg];
    NSArray *arrays = [NSArray arrayWithObjects:@"患者基本信息",@"手术信息",@"手术麻醉",@"器械品牌",@"器械合格证",@"X光片",@"术后视频",@"术后体位",nil];
    UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12, 100, 20)];
    titlLab.text = [NSString stringWithFormat:@"%@",arrays[section]];
    titlLab.font = [UIFont systemFontOfSize:14];
    titlLab.textColor = SetColor(0x1a1a1a);
    [heardView addSubview:titlLab];
    
    CGRect whiteRect = [titlLab boundingRectWithInitSize:titlLab.frame.size];
    titlLab.frame  = CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 12,whiteRect.size.width, 20);
    
    if (section == 4 || section == 5|| section == 6|| section == 7) {
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlLab.frame) + 5, 15, 18, 16)];
        images.image = [UIImage imageNamed:@"上传图片123"];
        [heardView addSubview:images];
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 7) {
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
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            static NSString *cellid = @"gender";
            ZJNSelectGenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNSelectGenderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
            cell.leftLabel.text = @"男";
            cell.rightLabel.text = @"女";
            NSString *gender = [NSString stringWithFormat:@"%@",self.patientInfoDic[@"gender"]];
            if ([gender isEqualToString:@"0"]) {
                cell.rightButton.selected = YES;
            }else{
                cell.leftButton.selected = YES;
            }
            return cell;
        }else{
            static NSString *cellid = @"info";
            ZJNTitleAndInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNTitleAndInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
            if (indexPath.row == 0) {
                cell.infoLabel.text = self.patientInfoDic[@"patientName"];
            }else if (indexPath.row == 2){
                cell.infoLabel.text = [NSString stringWithFormat:@"%@周岁",self.patientInfoDic[@"age"]];
            }else{
                if ((self.zhuyuanhao.length == 0)||[self.zhuyuanhao isEqualToString:@""]||[self.zhuyuanhao isEqualToString:@"(null)"]) {
                    cell.infoLabel.text = self.patientInfoDic[@"hospNum"];
                }else{
                    cell.infoLabel.text = self.zhuyuanhao;
                }
                
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        static NSString *cellid = @"textDield";
        ZJNTitleAndTextfieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNTitleAndTextfieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleArr[indexPath.section][indexPath.row];
        cell.textField.placeholder = placeHolderArr[indexPath.row];
        if (indexPath.row == 0  || indexPath.row == 6) {
            cell.textField.userInteractionEnabled = NO;
        }else{
            cell.textField.userInteractionEnabled = YES;
            [cell.textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellid = @"cellid";
        ZJNAnesthesiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNAnesthesiaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.titleLabel.text = @"麻醉方式";
        cell.firstLabel.text = list1[0][@"anesthesiaName"];
        cell.secondLabel.text = list1[1][@"anesthesiaName"];
        cell.thirdLabel.text = list1[2][@"anesthesiaName"];
        cell.fourthLabel.text = anestheName;

        return cell;
    }else if(indexPath.section == 3){
        ZJNArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNArrowTableViewCell" owner:self options:nil]lastObject];
        }
       
        cell.contentLabel.textColor = SetColor(0x666666);
        cell.contentLabel.hidden = YES ;
        UIScrollView *scrol = [[UIScrollView alloc]initWithFrame:CGRectMake(80, 0, ScreenWidth - 120, 44)];
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewScrollowView)];
        [scrol addGestureRecognizer:tapGesture];
        scrol.delegate = self;
        [cell.contentView addSubview:scrol];
        
        for (int a = 0; a  < chaungchangArr.count; a ++) {
            UILabel *guanLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + 70 * a, 7, 60, 30)];
            guanLab.text = [NSString stringWithFormat:@"%@",chaungchangArr[a][@"brandCompany"]];
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
                scrol.frame = CGRectMake(80, 0, ScreenWidth - 120, 44);
            }else{
                scrol.frame = CGRectMake(ScreenWidth - 5 - (60 + 20)* chaungchangArr.count + 20, 0, (60 + 20)* chaungchangArr.count - 20, 44);
            }
            scrol.contentSize = CGSizeMake((60 + 20)* chaungchangArr.count- 20,0);
            scrol.pagingEnabled = YES;
            
        }else{
            if (chaungchangArr.count > 4) {
                scrol.frame = CGRectMake(80, 0, ScreenWidth - 120, 44);
            }else{
                scrol.frame = CGRectMake(ScreenWidth - 5 - (60 + 20)* chaungchangArr.count + 20, 0, (60 + 20)* chaungchangArr.count - 20, 44);
            }
            scrol.contentSize = CGSizeMake((60 + 20)* chaungchangArr.count- 20,0);
            scrol.pagingEnabled = YES;
            
        }
 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"品牌选择";
        return cell;
    } else{
        static NSString *cellid = @"choose";
        ZJNChoosePicturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNChoosePicturesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 4) {
            cell.imageArray = qxImageArr;
        }else if (indexPath.section == 5){
            cell.imageArray = xImageArr;

        }else if (indexPath.section == 6){
            
            cell.imageArray = SHImageArr;
        }else if (indexPath.section == 7){
            cell.imageArray = SImageArr;
        }
        return cell;
    }
}
- (void)didViewScrollowView{

    QJCAddBrandViewController * BrandVc =[[QJCAddBrandViewController alloc]init];
    BrandVc.selectArray = chaungchangArr;
    BrandVc.returnZhuan = ^(NSMutableArray * _Nonnull selecet) {
        chaungchangArr = [[NSMutableArray alloc]initWithArray:selecet];
        NSMutableArray * barandArray =[[NSMutableArray alloc]init];
        for (NSDictionary * ddic in chaungchangArr) {
            [barandArray addObject:ddic[@"brandId"]];
            
        }
        self.requestModel.brandId = [barandArray componentsJoinedByString:@","];
        
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:BrandVc animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 && indexPath.row == 0) {
        [self didTimeButton];
    } else  if (indexPath.section ==1 && indexPath.row == 6){
        NSLog(@"214342");
        [self showActionSheetWithArray:showsurgeryTypeArray withType:nil];

    }else if(indexPath.section == 3 && indexPath.row == 0){
//        [self   showActionSheetWithArray:SurgeryBranddataArary withType:@"Pintpai"];
//        QJCAddBrandViewController * BrandVc =[[QJCAddBrandViewController alloc]init];
//        BrandVc.returnZhuan = ^(NSMutableArray * _Nonnull selecet) {
//            chaungchangArr = [[NSMutableArray alloc]initWithArray: BrandVc.selectArray];
//            [tableView reloadData];
//        };
//        [self.navigationController pushViewController:BrandVc animated:YES];
        
    }
    
}
#pragma mark--ZJNAnesthesiaTableViewCellDelegate
-(void)zjnAnesthesiaTableViewCellSelectButtonWithType:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        judge = 0;
        self.requestModel.anesthesiaId = list1[0][@"uid"];
        anestheName = @"请选择";

    }else if ([type isEqualToString:@"2"]){
        judge = 0;
        self.requestModel.anesthesiaId = list1[1][@"uid"];
        anestheName = @"请选择";

    }else if ([type isEqualToString:@"3"]){
        judge = 1;
        self.requestModel.anesthesiaId = list1[2][@"uid"];
    }else{
        if (judge == 0) {
            return;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.anesthesiaView];
    }
    [self.tableView reloadData];
}
#pragma mark--textField绑定方法
-(void)textFieldTextChanged:(UITextField *)textField{
    ZJNTitleAndTextfieldTableViewCell *cell = (ZJNTitleAndTextfieldTableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.row == 1) {
        self.requestModel.surgeryName = textField.text;
    }else if (indexPath.row == 2){
        self.requestModel.approach = textField.text;
    }else if (indexPath.row == 3){
        self.requestModel.attr2 = textField.text;
    }else if (indexPath.row == 4){
        self.requestModel.firstzs = textField.text;
    }else if (indexPath.row == 5){
        self.requestModel.twozs = textField.text;
    }
}
#pragma mark--ZJNChoosePCellDelegate
/*
 * 添加图片
 */
-(void)choosePicturesTableViewCellAddPicturesWithCell:(ZJNChoosePicturesTableViewCell *)cell{
    signIndexPath = [_tableView indexPathForCell:cell];
    if (signIndexPath.section == 6) {
        [self selectVideo];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhoto];
    }];
    [firstAction setValue:SetColor(0xf3b100) forKey:@"_titleTextColor"];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    [secondAction setValue:greenC forKey:@"_titleTextColor"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:greenC forKey:@"_titleTextColor"];
    [alertController addAction:firstAction];
    [alertController addAction:secondAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/*
 * 预览图片
 */
-(void)choosePicturesTableViewCellPreviewPictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell{
    
    signIndexPath = [_tableView indexPathForCell:cell];
    if(signIndexPath.section ==6){
 
//            NSDictionary *dic = SHArr[index];
        if ( SHArr.count < index) {
            return;
        }
            NSString *localPath = [NSString stringWithFormat:@"%@%@",imgPath, SHArr[index]];
            NSURL *videoURL = [NSURL URLWithString:localPath];
            MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
            moviePlayerController.hidesBottomBarWhenPushed = YES;
            [moviePlayerController.moviePlayer prepareToPlay];
            // moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            [self presentViewController:moviePlayerController animated:NO completion:nil];
            return;
            
    }
    
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
    signIndexPath = [_tableView indexPathForCell:cell];
    if (signIndexPath.section == 4) {
        [qxImageArr removeObjectAtIndex:index];
        [qxImagePathArr removeObjectAtIndex:index];
    }else if(signIndexPath.section == 5){
        [xImageArr removeObjectAtIndex:index];
        [xImagePathArr removeObjectAtIndex:index];
    }else if (signIndexPath.section == 6){
        [SHArr removeObjectAtIndex:index];
        [SHImageArr removeObjectAtIndex:index];
    }else if (signIndexPath.section == 7){
        [SImageArr removeObjectAtIndex:index];
        [SImagePathArr removeObjectAtIndex:index];
    }
    
    [_tableView reloadData];
}
#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    if (signIndexPath.section == 4) {
        return qxImageArr.count;
    }else if(signIndexPath.section == 5){
        return xImageArr.count;
    }else if(signIndexPath.section == 5){
//        return xImageArr.count;
    }else if(signIndexPath.section == 7){
        return xImageArr.count;
    }
    return 0;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photot;
    NSString * photimageStr;
    if (signIndexPath.section == 4) {
           photimageStr  =[NSString stringWithFormat:@"%@",qxImagePathArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
     }else if (signIndexPath.section == 5){
          photimageStr  =[NSString stringWithFormat:@"%@",xImagePathArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
 
    }else if (signIndexPath.section == 7){
           photimageStr  =[NSString stringWithFormat:@"%@",SImagePathArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
 
    }
    
    photimageStr = [photimageStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"imgs"];
    photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];

    
    return photot;
}
#pragma mark--从相册取照片或拍照
// 从系统相册选择按钮
- (void)selectPhoto{
    
    TZImagePickerController *tzController = [[TZImagePickerController alloc]initWithMaxImagesCount:16 delegate:self];
    if (signIndexPath.section == 4) {
        tzController.maxImagesCount = 16 - qxImagePathArr.count;
    }else  if (signIndexPath.section == 5){
        tzController.maxImagesCount = 16 - xImagePathArr.count;
    }else  if (signIndexPath.section == 7){
        tzController.maxImagesCount = 16 - SImagePathArr.count;
    }

    tzController.allowPreview = YES;
    tzController.allowPickingVideo = NO;
    tzController.allowPickingGif = NO;
    tzController.allowPickingOriginalPhoto = NO;
    [tzController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        NSMutableArray *publicArr = [NSMutableArray array];
        
        [publicArr addObjectsFromArray:photos];
        
        if (signIndexPath.section == 4) {
            [qxImageArr addObjectsFromArray:photos];
        }else  if (signIndexPath.section == 5) {
            [xImageArr addObjectsFromArray:photos];
        }
        else  if (signIndexPath.section == 7) {
            [SImageArr addObjectsFromArray:photos];
        }

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
        
    }];
}

// 拍照按钮
- (void)takePhoto{
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
        
    }
    imgPicker.delegate = self;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //获取用户选择或拍摄的是照片还是视频
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *imgage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSMutableArray *arraypublic = [NSMutableArray array];
        [arraypublic addObject:imgage];
        
        
        if (signIndexPath.section == 4) {
            [qxImageArr addObject:imgage];
        }else if (signIndexPath.section == 5) {
            [xImageArr addObject:imgage];
        }else if (signIndexPath.section == 6){
            NSData *data = UIImageJPEGRepresentation([Utile fixOrientation:imgage], proportion);
          shuShiPinStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            
        }
        else if (signIndexPath.section == 7) {
            
            [SImageArr addObject:imgage];
        }

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
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            //如果是拍摄的视频, 则把视频保存在系统多媒体库中
            NSLog(@"video path: %@", info[UIImagePickerControllerMediaURL]);
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeVideoAtPathToSavedPhotosAlbum:info[UIImagePickerControllerMediaURL] completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if (!error) {
                    
                    NSLog(@"视频保存成功");
                } else {
                    
                    NSLog(@"视频保存失败");
                }
            }];
        }
        
        //生成视频名称
        NSString *mediaName = [self getVideoNameBaseCurrentTime];
        NSLog(@"mediaName: %@", mediaName);
        
        //将视频存入缓存
        NSLog(@"将视频存入缓存");
        [self saveVideoFromPath:info[UIImagePickerControllerMediaURL] toCachePath:[VIDEOCACHEPATH stringByAppendingPathComponent:mediaName]];
        
        //创建uploadmodel
        uploadModel *model = [[uploadModel alloc] init];
        
        model.path       = [VIDEOCACHEPATH stringByAppendingPathComponent:mediaName];
        model.name       = mediaName;
        model.type       = @"moive";
        model.isUploaded = NO;
        
        //将model存入待上传数组
//        [uploadArray addObject:model];
        
        [self uploadImageAndMovieBaseModel:model];
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
    }

    
}
#pragma mark  上传视频
- (void)uploadImageAndMovieBaseModel:(uploadModel *)model {
    
    //获取文件的后缀名
    NSString *extension = [model.name componentsSeparatedByString:@"."].lastObject;
    
    //设置mimeType
    NSString *mimeType;
    if ([model.type isEqualToString:@"image"]) {
        
        mimeType = [NSString stringWithFormat:@"image/%@", extension];
    } else {
        
        mimeType = [NSString stringWithFormat:@"video/%@", extension];
    }
    
    //创建AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置响应文件类型为JSON类型
    manager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    
    //初始化requestSerializer
    manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = nil;
    
    //设置timeout
    [manager.requestSerializer setTimeoutInterval:20.0];
    
    //设置请求头类型
    [manager.requestSerializer setValue:@"form/data" forHTTPHeaderField:@"Content-Type"];
    
    //设置请求头, 授权码
    [manager.requestSerializer setValue:@"YgAhCMxEehT4N/DmhKkA/M0npN3KO0X8PMrNl17+hogw944GDGpzvypteMemdWb9nlzz7mk1jBa/0fpOtxeZUA==" forHTTPHeaderField:@"Authentication"];
    
    //上传服务器接口
    NSString *url = [NSString stringWithFormat:@"%@%@",requestUrl,videoing];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    //开始上传
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSError *error;
        BOOL success = [formData appendPartWithFileURL:[NSURL fileURLWithPath:model.path] name:model.name fileName:model.name mimeType:mimeType error:&error];
        if (!success) {
            
            NSLog(@"appendPartWithFileURL error: %@", error);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"上传进度: %f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dica = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"成功返回: %@",dica);
        NSString *retcode = [NSString stringWithFormat:@"%@",dica[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [SHArr addObject:dica[@"filepath"]];
        }
        NSString *pathss = [NSString stringWithFormat:@"%@%@",imgPath,dica[@"filepath"]];
        NSURL * url = [NSURL URLWithString:pathss];
//         UIImage * imageing = [Utile imageWithMediaURL:url];
        [SHImageArr addObject:[Utile imageWithMediaURL:url]];
        [_tableView reloadData];
        [self hideHud];
        model.isUploaded = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        NSLog(@"上传失败: %@", error);
        model.isUploaded = NO;
    }];
}
//将视频保存到缓存路径中
- (void)saveVideoFromPath:(NSString *)videoPath toCachePath:(NSString *)path {
    
    NSFileManager *fileManagers = [NSFileManager defaultManager];
    if (![fileManagers fileExistsAtPath:VIDEOCACHEPATH]) {
        
        NSLog(@"路径不存在, 创建路径");
        [fileManagers createDirectoryAtPath:VIDEOCACHEPATH
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
    }
    NSError *error;
    [fileManagers copyItemAtPath:videoPath toPath:path error:&error];
    if (error) {
        NSLog(@"文件保存到缓存失败");
    }
}
//以当前时间合成视频名称
- (NSString *)getVideoNameBaseCurrentTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    
    return [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:@".MOV"];
}

-(void)postImageToServerWithPath:(NSString *)path{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,uploadimageUpload];
    NSDictionary *dic = @{@"fromFile":path};
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"图片上传%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            if (signIndexPath.section == 4) {
                [qxImagePathArr addObjectsFromArray:array];
            }else  if (signIndexPath.section == 5){
                [xImagePathArr addObjectsFromArray:array];
            }else  if (signIndexPath.section == 7){
                [SImagePathArr addObjectsFromArray:array];
            }
            [_tableView reloadData];
        }else{
            [self hideHud];
            [self showHint:@"提交失败请重试"];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"图片上传%@",error);
    }];
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
    self.requestModel.surgeryTime = [NSString stringWithFormat:@"%@", date];
    ZJNTitleAndTextfieldTableViewCell *cell = (ZJNTitleAndTextfieldTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.textField.text = self.requestModel.surgeryTime;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
}
#pragma mark--提交按钮点击实现方法
-(void)didNextBtn{
    self.requestModel.qx = [qxImagePathArr componentsJoinedByString:@","];
    self.requestModel.imagex = [xImagePathArr componentsJoinedByString:@","];
    self.requestModel.imaget = [SImagePathArr componentsJoinedByString:@","];
    self.requestModel.video =[SHArr componentsJoinedByString:@","];
    self.requestModel.hospnumId = self.patientInfoDic[@"hospnumId"];
    NSDictionary *dic = [self returnToDictionaryWithModel:self.requestModel];
    
    if (!self.requestModel.surgeryTime) {
        [self showHint:@"请填写日期后提交！"];
        return ;
    }
    if(!self.requestModel.surgeryType){
        [self showHint:@"请选择手术分类后提交！"];
        return ;
    }
    NSLog(@"%@",dic);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientsurgical_save];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"手术记录提交%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshShouShuInfo" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MainViewController" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        [self hideHud];
        [self showHint:data[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"手术记录提交%@",error);
    }];
}
-(NSMutableDictionary *)returnToDictionaryWithModel:(ZJNAddOperationRequestModel *)model
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([ZJNAddOperationRequestModel class], &count);
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
    free(properties);
    
    return userDic;
}
#pragma mark  获取品牌接口
//-(void)makeZhuJian{
//
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,shoushusurgeryBrand];
//    [self showHudInView:self.view hint:nil];
//    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
//        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
//        if ([retcode isEqualToString:@"0000"]) {
//
//            /*
//             brandCompany = "\U516c\U53f8";
//             brandId = 1;
//             brandName = "\U5047\U80a2";
//             */
//            SurgeryBranddataArary =[[NSArray alloc]initWithArray:data[@"data"]];
//
//        }
//         [self hideHud];
////        [self showHint:data[@"message"]];
//    } failure:^(NSError *error) {
//        [self hideHud];
//     }];
//
//
//}

//-(void)showActionSheetWithArray:(NSArray *)array withType:(NSString *)type{
//    ZJNArrowTableViewCell *cell;
//    if ([type isEqualToString:@"Pintpai"]) {
//        cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
//    }
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    for (int i = 0; i <array.count; i ++) {
//        NSDictionary *dic = array[i];
//        NSString *title;
//        if ([type isEqualToString:@"Pintpai"]) {
//            title = dic[@"brandCompany"];
//        }
//        UIAlertAction *firstAct = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            if ([type isEqualToString:@"Pintpai"]) {
//
//                self.requestModel.brandId = dic[@"brandId"];
//                selectSurgerydic = dic;
//            }
//            [_tableView reloadData];
//        }];
//        [alert addAction:firstAct];
//        [firstAct setValue:greenC forKey:@"_titleTextColor"];
//    }
//
//    UIAlertAction *thirdAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:thirdAct];
//
//    [thirdAct setValue:[UIColor redColor] forKey:@"_titleTextColor"];
//
//    if (array.count >5) {
//        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:350];
//        [alert.view addConstraint:height];
//    }
//    if([ZJNDeviceInfo deviceIsPhone]){
//
//        [self presentViewController:alert animated:YES completion:nil];
//
//    }else{
//
//        UIPopoverPresentationController *popPresenter = [alert
//                                                         popoverPresentationController];
//        popPresenter.sourceView = cell; // 这就是挂靠的对象
//        popPresenter.sourceRect = cell.bounds;
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}
//获取视频
-(void)selectVideo{
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc]init];
        
    }
    UIAlertController *alertController = \
    [UIAlertController alertControllerWithTitle:@""
                                        message:@"上传视频"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAction = \
    [UIAlertAction actionWithTitle:@"从视频库选择"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               
                               NSLog(@"从视频库选择");
                               imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                               imgPicker.hidesBottomBarWhenPushed = YES;
                               imgPicker.mediaTypes = @[(NSString *)kUTTypeMovie];
                               imgPicker.allowsEditing = NO;
                               imgPicker.delegate = self;
                               [self presentViewController:imgPicker animated:YES completion:^{
                                   
                               }];
                           }];
    
    UIAlertAction *cameraAction = \
    [UIAlertAction actionWithTitle:@"录像"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               
                               NSLog(@"录像");
                               imgPicker.delegate = self;
                               imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                               imgPicker.hidesBottomBarWhenPushed = YES;
                               imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                               imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                               imgPicker.videoQuality = UIImagePickerControllerQualityType640x480;
                               imgPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                               
                               imgPicker.allowsEditing = YES;
                               
                               [self presentViewController:imgPicker animated:YES completion:^{
                                   
                               }];
                           }];
    
    UIAlertAction *cancelAction = \
    [UIAlertAction actionWithTitle:@"取消"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction * _Nonnull action) {
                               
                               NSLog(@"取消");
                           }];
    
    [alertController addAction:photoAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    if([ZJNDeviceInfo deviceIsPhone]){
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = self.view; // 这就是挂靠的对象
        popPresenter.sourceRect = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        [self presentViewController:alertController animated:YES completion:nil];
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
