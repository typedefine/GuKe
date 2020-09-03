//
//  MedicalRecordsViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MedicalRecordsViewController.h"
#import "MedicalPatientInfoTableViewCell.h"
#import "MedicalLifeSignsTableViewCell.h"
#import "MedicalDoctorInfoTableViewCell.h"
#import "MedicalChooseStyleTableViewCell.h"
#import "MedicalContentTableViewCell.h"
#import "ZJNScrollTableViewCell.h"
#import "ZJNGradeTableViewCell.h"
#import "MedicalRecordsImageTableViewCell.h"
#import "ZJNMRSharesTableViewCell.h"
#import "MedicalRecordsModel.h"
#import "MWPhotoBrowser.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PingfenModel.h"
//邀请病历共享者
#import "ZJNMRShareDoctorViewController.h"
//修改患者基本信息
#import "ZJNChangePatientBasicInfoViewController.h"
#import "ZJNChangePatientBasicInfoModel.h"
//修改患者体征信息
#import "ZJNChangePatientBodyInfoViewController.h"
#import "ZJNChangePatientBodyInfoModel.h"
//修改检查结果
#import "ZJNChangeCheckResultViewController.h"
#import "ZJNChangeCheckResultModel.h"
//修改病例报告
#import "ZJNUploadInvoicesViewController.h"
#define imageWidth (ScreenWidth-50)/4
@interface MedicalRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,medicalRecordsImageDelegate,MWPhotoBrowserDelegate>
{
    UITableView *_tableView;
    MedicalRecordsModel *infoModel;
    NSString *reportStr;
    NSArray *contentArr;
    MWPhotoBrowser *browser;
}
@end

@implementation MedicalRecordsViewController
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic{
    self = [super init];
    if (self) {
        self.patientInfoDic = patientInfoDic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    reportStr = @"hy";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self makeData];
    // Do any additional setup after loading the view.
}
#pragma mark 数据请求 我的患者--就诊记录
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_visit];
    NSString *hopitals = [[NSUserDefaults standardUserDefaults]objectForKey:@"hospitalnumbar"];
    
    NSArray *keysArray = @[@"hospid",@"sessionid"];
    NSArray *valueArray = @[hopitals,sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的患者--就诊记录%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            infoModel = [MedicalRecordsModel yy_modelWithDictionary:data[@"data"]];
            infoModel.forms = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in data[@"data"][@"forms"]) {
                PingfenModel * mode = [PingfenModel yy_modelWithJSON:dic];
                [infoModel.forms addObject:mode];
             
            }
            
            
            if (self.backHospitalIdBlock) {
                NSDictionary *dic = @{@"id":infoModel.hospid,@"name":infoModel.doctorName};
                self.backHospitalIdBlock(dic);
            }
            [_tableView reloadData];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的患者--就诊记录%@",error);
    }];
    
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4){
        return 10;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *address = [NSString stringWithFormat:@"%@%@",infoModel.area,infoModel.homeadress];
        CGSize size = [self textHeightWithString:address];
        CGFloat addHeight = size.height-20;
        return MAX(210, 210+addHeight);
    }else if (indexPath.section == 1){
        NSArray *sharesArr = infoModel.share;
        NSInteger a = sharesArr.count/6;
        NSInteger b = sharesArr.count%6;
        if (b>0) {
            a += 1;
        }
        return a *((ScreenWidth-70)/6.0+30+10)+10;
    }else if (indexPath.section == 2){
        return 110;
    }else if (indexPath.section == 3){
        return 95;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            NSString *allergyStr = infoModel.allergyName;
            CGSize size = [self textHeightWithString:allergyStr];
            return MAX(70, 50+size.height);
        }else if (indexPath.row == 1){
            return 44;
        }else if (indexPath.row == 2){
            NSString *diagnosisStr = infoModel.chief;
            CGSize size = [self textHeightWithString:diagnosisStr contentSize:CGSizeMake(ScreenWidth-110, MAXFLOAT)];
            return MAX(44, 30+size.height);
        }else if (indexPath.row == 3){
            NSString *diagnosisStr = infoModel.diagnosis;
            CGSize size = [self textHeightWithString:diagnosisStr contentSize:CGSizeMake(ScreenWidth-110, MAXFLOAT)];
            return MAX(44, 30+size.height);
        }else if (indexPath.row == 4){
            NSString *hpiSre = infoModel.hpi;
            CGSize size = [self textHeightWithString:hpiSre contentSize:CGSizeMake(ScreenWidth-110, MAXFLOAT)];
            return MAX(44, 30+size.height);
        }else if (indexPath.row == 5){
            NSString *historyStr = infoModel.history;
            CGSize size = [self textHeightWithString:historyStr contentSize:CGSizeMake(ScreenWidth-120, MAXFLOAT)];
            return MAX(44, 30+size.height);
        }else if (indexPath.row == 6){
            NSString *checksStr = infoModel.checks;
            CGSize size = [self textHeightWithString:checksStr contentSize:CGSizeMake(ScreenWidth-110, MAXFLOAT)];
            return MAX(44, 30+size.height);
        }else if (indexPath.row == 7){
            NSString *ecgStr = infoModel.ecgName;
            CGSize size = [self textHeightWithString:ecgStr];
            return MAX(70, 50+size.height);
        }else if (indexPath.row == 8){
            NSString *imagingStr = infoModel.imagingName;
            CGSize size = [self textHeightWithString:imagingStr];
            return MAX(70, 50+size.height);
        }else{
            return 36* infoModel.forms.count;
        }
    }else{
        
        NSInteger x = contentArr.count%4;
        NSInteger y = contentArr.count/4;
        if (x >0 || y == 0) {
            y += 1;
        }
        return 45+y*(imageWidth+10);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return 60;
    }
    return 0.01;
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
        titlLab.text = @"患者信息";
    }else if (section == 1){
        titlLab.text = @"病例共享者";
    }else if (section == 2){
        titlLab.text = @"生命体征";
    }else if (section == 3){
        titlLab.text = @"医院医生信息";
    }else if (section == 4){
        titlLab.text = @"检查记录";
    }else{
        titlLab.text = @"病例报告";
    }
    if (section == 0 || section == 2 || section == 4 || section == 5) {
        ;// 此病例是自己创建的我能编辑

        if ([[self.patientInfoDic objectForKey:@"shares"] isEqualToString:@"0"]) {
            UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            changeButton.frame = CGRectMake(ScreenWidth-44, 0, 44, 44);
            [changeButton setImage:[UIImage imageNamed:@"编辑icon"] forState:UIControlStateNormal];
            changeButton.tag = section;
            [changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [heardView addSubview:changeButton];
        }
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellid = @"cellid";
        MedicalPatientInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalPatientInfoTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = infoModel;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellid = @"share";
        ZJNMRSharesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNMRSharesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid cellType:ZJNMRSharesTableViewCellShow];
        }
        cell.dataArray = infoModel.share;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellid = @"celliD";
        MedicalLifeSignsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalLifeSignsTableViewCell" owner:self options:nil]lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = infoModel;
        return cell;
    }else if (indexPath.section == 3){
        static NSString *cellid = @"cellID";
        MedicalDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalDoctorInfoTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = infoModel;
        return cell;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0 || indexPath.row == 7|| indexPath.row == 8) {
            static NSString *cellid = @"celLID";
            MedicalChooseStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalChooseStyleTableViewCell" owner:self options:nil]lastObject];
            }
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"药物过敏史";
                cell.leftLabel.text = @"无";
                cell.middleLabel.text = @"有";
                if ([[NSString changeNullString:infoModel.allergy] isEqualToString:@"1"]) {
                    cell.selectedImageView.image = [UIImage imageNamed:@"性别_选中"];
                }else{
                    cell.diselectedImageView.image = [UIImage imageNamed:@"性别_选中"];
                }
                cell.contentLabel.text = infoModel.allergyName;
            }else if (indexPath.row == 7){
                cell.titleLabel.text = @"心电图检查";
                if ([[NSString changeNullString:infoModel.ecg] isEqualToString:@"0"]) {
                    cell.selectedImageView.image = [UIImage imageNamed:@"性别_选中"];
                }else{
                    cell.diselectedImageView.image = [UIImage imageNamed:@"性别_选中"];
                }
                cell.contentLabel.text = infoModel.ecgName;
            }else{
                cell.titleLabel.text = @"影像学检查";
                if ([[NSString changeNullString:infoModel.imaging] isEqualToString:@"0"]) {
                    cell.selectedImageView.image = [UIImage imageNamed:@"性别_选中"];
                }else{
                    cell.diselectedImageView.image = [UIImage imageNamed:@"性别_选中"];
                }
                cell.contentLabel.text = infoModel.imagingName;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 4||indexPath.row == 5||indexPath.row == 6){
            static NSString *cellid = @"ceLLID";
            MedicalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalContentTableViewCell" owner:self options:nil]lastObject];
            }
            if (indexPath.row == 2) {
                cell.titleLabel.text = @"主诉";
                cell.contentLabel.text = infoModel.chief;
            }else if (indexPath.row == 3) {
                cell.titleLabel.text = @"诊断";
                cell.contentLabel.text = infoModel.diagnosis;
            }else if (indexPath.row == 4){
                cell.titleLabel.text = @"现病史";
                cell.contentLabel.text = infoModel.hpi;
            }else if (indexPath.row == 5){
                cell.titleLabel.text = @"既往史";
                cell.contentLabel.text = infoModel.history;
            }else{
                cell.titleLabel.text = @"专科检查";
                cell.contentLabel.text = infoModel.checks;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            static NSString *cellid = @"cELLID";
            ZJNScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNScrollTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            
            cell.typeArray = infoModel.joints;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"关节";
            return cell;
        }else{
            static NSString *cellid = @"CELLID";
            ZJNGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNGradeTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.PingfenArray = infoModel.forms;
            return cell;
        }
    }else{
        static NSString *cellid = @"celliden";
        MedicalRecordsImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MedicalRecordsImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid topStyle:@"noTopButton"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *revisit = infoModel.revisit;
        NSDictionary *dic = revisit[0];
        cell.delegate = self;
        
        if ([reportStr isEqualToString:@"hy"]) {
            contentArr = dic[@"hyimages"];
            
        }else if ([reportStr isEqualToString:@"X"]){
            contentArr = dic[@"ximages"];
        }else if ([reportStr isEqualToString:@"tw"]){
            contentArr = dic[@"twimages"];
        }else{
            contentArr = infoModel.videos;
        }
        cell.imageArray = contentArr;
        return cell;
    }
}
#pragma mark--medicalRecordsImageDelegate
-(void)switchImageArrayWithType:(NSString *)type withCell:(MedicalRecordsImageTableViewCell *)cell{
    reportStr = type;
    [_tableView reloadData];
}
-(void)showImageWithIndex:(NSInteger)index withCell:(MedicalRecordsImageTableViewCell *)cell{
    if ([reportStr isEqualToString:@"videos"]) {
        
        NSDictionary *dic = contentArr[index];
        NSString *localPath = [NSString stringWithFormat:@"%@%@",imgPath,[dic objectForKey:@"path"]];
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
#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return contentArr.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    NSDictionary *dic = contentArr[index];
 
    NSString * photimageStr  =[NSString stringWithFormat:@"%@",dic[@"path"]];
    if ([photimageStr containsString:imgPath]) {
    }else{
        photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];

    }
    photimageStr = [photimageStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"imgs"];
 
    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];

    return photot;
}

#pragma mark--计算文字高度
-(CGSize)textHeightWithString:(NSString *)string{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
    return [string boundingRectWithSize:CGSizeMake(ScreenWidth-141, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
-(CGSize)textHeightWithString:(NSString *)string contentSize:(CGSize)contentSize{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
    return [string boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark 修改资料
-(void)changeButtonClick:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    if (button.tag == 0) {
        //修改患者基本信息
        ZJNChangePatientBasicInfoViewController *viewC = [[ZJNChangePatientBasicInfoViewController alloc]init];
        viewC.infoModel = [[ZJNChangePatientBasicInfoModel alloc]initWithMedicalInfoModel:infoModel];
        viewC.refershPatientInfo = ^{
            NSLog(@"刷新页面");
            [self makeData];
        };
        [self.navigationController pushViewController:viewC animated:YES];
    }else if (button.tag == 2){
        //修改生命体征
        ZJNChangePatientBodyInfoViewController *viewC = [[ZJNChangePatientBodyInfoViewController alloc]init];
        viewC.infoModel = [[ZJNChangePatientBodyInfoModel alloc]initWithMedicalInfoModel:infoModel];
        viewC.refreshBodyInfoBlock = ^{
            [weakSelf makeData];
        };
        [self.navigationController pushViewController:viewC animated:YES];
    }else if(button.tag == 4){
        //修改检查记录
        ZJNChangeCheckResultViewController *viewC = [[ZJNChangeCheckResultViewController alloc]init];
        viewC.infoModel = [[ZJNChangeCheckResultModel alloc]initWithMedicalModel:infoModel];
        viewC.refreshMedicalRecord = ^{
        
            [weakSelf makeData];
  
        };
        [self.navigationController pushViewController:viewC animated:YES];
        
        
    }else{
        NSLog(@"修改上传的图片");
        NSMutableArray *hyArr = [NSMutableArray array];
        NSMutableArray *xgArr = [NSMutableArray array];
        NSMutableArray *twArr = [NSMutableArray array];
        NSMutableArray *videoArr = [NSMutableArray array];
        NSDictionary *imageDic = infoModel.revisit[0];
        
        for (NSDictionary *dic in imageDic[@"hyimages"]) {
            [hyArr addObject:dic[@"path"]];
        }
        for (NSDictionary *dic in imageDic[@"ximages"]) {
            [xgArr addObject:dic[@"path"]];
        }
        for (NSDictionary *dic in imageDic[@"twimages"]) {
            [twArr addObject:dic[@"path"]];
        }
        for (NSDictionary *dic in infoModel.videos) {
            [videoArr addObject:dic[@"path"]];
        }
        
        ZJNUploadInvoicesViewController *viewC = [[ZJNUploadInvoicesViewController alloc]initWithUploadInvoicesType:UploadInvoicesFromChangePatient];
        viewC.reloadDataBlock = ^{
            [weakSelf makeData];

        };
        viewC.hyArr = hyArr;
        viewC.xgArr = xgArr;
        viewC.twArr = twArr;
        viewC.videoArr = videoArr;
        viewC.type = UploadInvoicesFromChangePatientImage;
        viewC.checkID = infoModel.hospid;
        viewC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewC animated:YES];
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
