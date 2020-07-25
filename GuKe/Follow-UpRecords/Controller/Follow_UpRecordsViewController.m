//
//  Follow-UpRecordsViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "Follow_UpRecordsViewController.h"
#import "Follow_UpRecordsBasicInfoTableViewCell.h"
#import "Follow_UpDoctorDateTableViewCell.h"
#import "MedicalLifeSignsTableViewCell.h"
#import "MedicalContentTableViewCell.h"
#import "ZJNGradeTableViewCell.h"
#import "MedicalRecordsImageTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Follow_UpRecordsModel.h"
#import "Follow_UpRecordsRevisitModel.h"
#import "ZJNChangeFollowUpViewController.h"
#import "DuiBiViewController.h"
#import "MWPhotoBrowser.h"
#import "ZJNChangeFollowUpRequestModel.h"
#import "ZJNUploadInvoicesViewController.h"
#define imageWidth (ScreenWidth-50)/4
@interface Follow_UpRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,medicalRecordsImageDelegate,MWPhotoBrowserDelegate,follow_UpRecordsBasicInfoDelegate>
{
    UITableView *_tableView;
    Follow_UpRecordsModel *infoModel;
    NSArray *contentArr;
    MWPhotoBrowser *browser;
    NSArray *timeArr;
    NSIndexPath *signIndexPath;
}
@end

@implementation Follow_UpRecordsViewController
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic{
    self = [super init];
    if (self) {
        self.patientInfoDic = patientInfoDic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refershRecords) name:@"refreshPatientInfo" object:nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self makeData];
    // Do any additional setup after loading the view.
}
#pragma mark 我的患者--随访记录
- (void)makeData{
    NSString *hopitals = [[NSUserDefaults standardUserDefaults]objectForKey:@"hospitalnumbar"];;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_revisit];
    
    NSArray *keysArray = @[@"hospid",@"sessionid"];
    NSArray *valueArray = @[hopitals,sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        
        NSLog(@"我的患者--随访记录%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            infoModel = [[Follow_UpRecordsModel alloc]initModelWithDictionart:data[@"data"]];
        }
        [self showHint:data[@"message"]];
        [_tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的患者--随访记录%@",error);
    }];
    
}
#pragma mark 我的患者--随访记录 --对比时间
- (void)makeTimeDataWithModel:(Follow_UpRecordsRevisitModel *)model withCell:(MedicalRecordsImageTableViewCell *)cell{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_time];
    NSArray *keysArray = @[@"sessionid",@"visitid",@"hospnumid"];
    NSArray *valueArray = @[sessionIding,model.uid,model.hospnumId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的患者--随访记录 --对比时间%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            timeArr = [NSArray arrayWithArray:data[@"data"]];
            [self showActionSheetWithModel:model withCell:cell];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的患者--随访记录 --对比时间%@",error);
    }];
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1+infoModel.revisit.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 95;
    }else{
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row == 1){
            return 110;
        }else if (indexPath.row == 2){
            Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
            NSString *checksStr = model.checks;
            CGSize size = [self textHeightWithString:checksStr];
            return MAX(44, 30+size.height);
            
        }else if (indexPath.row == 3){
            Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];

            return 36 * [model.PingfenArray count];
        }else{
            NSArray *imageArray;
            Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
            if ([model.selectedButton isEqualToString:@"hy"]) {
                imageArray = model.hyimages;
            }else if ([model.selectedButton isEqualToString:@"X"]){
                imageArray = model.ximages;
            }else if ([model.selectedButton isEqualToString:@"tw"]){
                imageArray = model.twimages;
            }else{
                imageArray = model.videos;
                
            }
            NSInteger x = imageArray.count%4;
            NSInteger y = imageArray.count/4;
            if (x >0 || y == 0) {
                y += 1;
            }
            return 80+y*(imageWidth+10);
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == infoModel.revisit.count) {
        return 60;
    }
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
        titlLab.text = @"患者基本信息";
    }else{
        titlLab.text = @"随访信息";
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
        Follow_UpRecordsBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"Follow_UpRecordsBasicInfoTableViewCell" owner:self options:nil]lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = infoModel;
        return cell;
    }else{
        Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
        if (indexPath.row == 0) {
            static NSString *cellid = @"celliD";
            Follow_UpDoctorDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"Follow_UpDoctorDateTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.doctorNameLabel.text = [NSString changeNullString:model.doctorName];
            cell.dateLabel.text = [NSString changeNullString:model.visitTime];
            return cell;
        }else if (indexPath.row == 1){
            static NSString *cellid = @"cellID";
            MedicalLifeSignsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalLifeSignsTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tempLabel.text = [NSString changeNullString:model.temperature];
            cell.breathLabel.text = [NSString changeNullString:model.breathe];
            cell.tapLabel.text = [NSString changeNullString:model.pulse];
            cell.bpLabel.text = [NSString changeNullString:model.pressure];
            return cell;
        }else if (indexPath.row == 2){
            static NSString *cellid = @"celLID";
            MedicalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MedicalContentTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"专科检查";
            cell.contentLabel.text = [NSString changeNullString:model.checks];
            return cell;
        }else if (indexPath.row == 3){
            static NSString *cellid = @"ceLLID";
            ZJNGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNGradeTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.PingfenArray = model.PingfenArray;
//            cell.firstLineRightButton.hidden = YES;
//            cell.secondLineRightButton.hidden = YES;
//            cell.thirdLineRightButton.hidden = YES;
//            cell.harrisString = model.harris;
//            cell.HSSString = model.hss;
//            cell.SF_12String = model.sf;
            return cell;
        }else{
            NSString *cellid = [NSString stringWithFormat:@"cELLID%ld",indexPath.section];
            MedicalRecordsImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[MedicalRecordsImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid topStyle:@"topButton"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
            if ([model.selectedButton isEqualToString:@"hy"]) {
                cell.imageArray = model.hyimages;
                UIButton *button = (UIButton *)[cell viewWithTag:10];
                button.selected = YES;
            }else if ([model.selectedButton isEqualToString:@"X"]){
                cell.imageArray = model.ximages;
                UIButton *button = (UIButton *)[cell viewWithTag:11];
                button.selected = YES;
            }else if ([model.selectedButton isEqualToString:@"tw"]){
                cell.imageArray = model.twimages;
                UIButton *button = (UIButton *)[cell viewWithTag:12];
                button.selected = YES;
            }else{
                cell.imageArray = model.twimages;
                UIButton *button = (UIButton *)[cell viewWithTag:13];
                button.selected = YES;

                cell.imageArray = model.videos;
            }
            return cell;
        }
    }
}
#pragma mark--medicalRecordsImageDelegate
-(void)switchImageArrayWithType:(NSString *)type withCell:(MedicalRecordsImageTableViewCell *)cell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
    model.selectedButton = type;
    
    [_tableView reloadData];
}
-(void)showImageWithIndex:(NSInteger)index withCell:(MedicalRecordsImageTableViewCell *)cell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
    if ([model.selectedButton isEqualToString:@"hy"]) {
        contentArr = model.hyimages;
    }else if ([model.selectedButton isEqualToString:@"X"]){
        contentArr = model.ximages;
    }else if ([model.selectedButton isEqualToString:@"tw"]){
        contentArr = model.twimages;
    }else{
        NSArray *videosArr = model.videos;
        
        NSDictionary *dic = videosArr[index];
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
-(void)comPareInfoWithCell:(MedicalRecordsImageTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
    
    [self makeTimeDataWithModel:model withCell:cell];
}
-(void)editImageWithCell:(MedicalRecordsImageTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    Follow_UpRecordsRevisitModel *model = infoModel.revisit[indexPath.section-1];
    NSMutableArray *hyArr = [NSMutableArray array];
    NSMutableArray *xgArr = [NSMutableArray array];
    NSMutableArray *twArr = [NSMutableArray array];
    NSMutableArray *videoArr = [NSMutableArray array];
    
    for (NSDictionary *dic in model.hyimages) {
        [hyArr addObject:dic[@"path"]];
    }
    for (NSDictionary *dic in model.ximages) {
        [xgArr addObject:dic[@"path"]];
    }
    for (NSDictionary *dic in model.twimages) {
        [twArr addObject:dic[@"path"]];
    }
    for (NSDictionary *dic in model.videos) {
        [videoArr addObject:dic[@"path"]];
    }
    
    ZJNUploadInvoicesViewController *viewC = [[ZJNUploadInvoicesViewController alloc]initWithUploadInvoicesType:UploadInvoicesFromChangeFollow_UP];
    viewC.checkID = model.uid;
    viewC.hyArr = hyArr;
    viewC.xgArr = xgArr;
    viewC.twArr = twArr;
    viewC.videoArr = videoArr;
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:YES];
    
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
#pragma mark--打电话--follow_UpRecordsBasicInfoDelegate
-(void)makeAPhoneWithNumber:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

#pragma mark--展示时间
-(void)showActionSheetWithModel:(Follow_UpRecordsRevisitModel *)model withCell:(MedicalRecordsImageTableViewCell *)cell{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    for (int i = 0; i <timeArr.count; i ++) {
        NSDictionary *dic = timeArr[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",dic[@"compareTime"]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"所选时间");
            DuiBiViewController *dui = [[DuiBiViewController alloc]init];
            dui.strOne = model.uid;
            dui.strTwo = dic[@"uid"];
            dui.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dui animated:NO];
            
        }];
        [action setValue:[UIColor colorWithHex:0x333333] forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
    if (timeArr.count >5) {
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:350];
        [alertController.view addConstraint:height];
    }
    
    [alertController addAction:action1];
    if([ZJNDeviceInfo deviceIsPhone]){
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = cell; // 这就是挂靠的对象
        popPresenter.sourceRect = cell.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark--添加随访记录后 刷新页面
-(void)refershRecords{
    [self makeData];
}
#pragma mark--计算文字高度
-(CGSize)textHeightWithString:(NSString *)string{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
    return [string boundingRectWithSize:CGSizeMake(ScreenWidth-95, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark--编辑按钮点击实现方法
-(void)changeButtonClick:(UIButton *)button{
    ZJNChangeFollowUpRequestModel *model = [[ZJNChangeFollowUpRequestModel alloc]initWithModel:infoModel.revisit[button.tag-1]];
    ZJNChangeFollowUpViewController *viewC = [[ZJNChangeFollowUpViewController alloc]init];
    viewC.hidesBottomBarWhenPushed = YES;
    viewC.model = model;
    [self.navigationController pushViewController:viewC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self makeData];

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
