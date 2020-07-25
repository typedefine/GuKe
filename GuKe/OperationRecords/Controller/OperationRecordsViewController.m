//
//  OperationRecordsViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "OperationRecordsViewController.h"
#import "PatientsBasicInfoTableViewCell.h"
#import "OperationInfoTableViewCell.h"
#import "ZJNOperationTableViewCell.h"
#import "TitleAndImageViewTableViewCell.h"
#import "OperationRecordInfoModel.h"
#import "OperationInfoModel.h"
#import "MWPhotoBrowser.h"
#import "ZJNChangeOperationViewController.h"
#import "AddFollow_UpRecordsViewController.h"
#import "ZJNChangeOperationRequestModel.h"
#define imageWidth (ScreenWidth-30-20)/3
#define imageHeight 0.77*imageWidth
@interface OperationRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,titleAndImageViewTableViewCellDelegate>
{
    UITableView *_tableView;
    OperationRecordInfoModel *infoModel;
    MWPhotoBrowser *browser;
    NSIndexPath    *signIndexPath;
    NSDictionary *TwoDic;
}
@end

@implementation OperationRecordsViewController
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic{
    self = [super init];
    if (self) {
        self.patientInfoDic = patientInfoDic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refershView) name:@"refreshShouShuInfo" object:nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self makeData];
    // Do any additional setup after loading the view.
}
#pragma mark--从服务器请求数据
- (void)makeData{
    NSString *hopitals = [[NSUserDefaults standardUserDefaults]objectForKey:@"hospitalnumbar"];;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_surgical];
    NSArray *keysArray = @[@"hospid",@"sessionid"];
    NSArray *valueArray = @[hopitals,sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的患者--手术记录%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            TwoDic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
            infoModel = [OperationRecordInfoModel yy_modelWithDictionary:data[@"data"]];
            [_tableView reloadData];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的患者--手术记录%@",error);
    }];
    
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1+infoModel.surgery.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 115;
    }else{
        if (indexPath.row == 0) {
            return 170;
        }else{
            OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[indexPath.section-1]];
            NSArray *imagesArray;
            if (indexPath.row == 1) {
                imagesArray = model.images;
            }else if (indexPath.row == 2){
                imagesArray = model.imagex;
            }
            else if (indexPath.row == 3){
                imagesArray = model.video;
            }
            else if (indexPath.row == 4){
                imagesArray = model.imaget;
            }
            NSInteger x = imagesArray.count%3;
            NSInteger y = imagesArray.count/3;
            
            if (x>0) {
                y+=1;
            }
            if (imagesArray.count == 0) {
                return 50;
            }else{
                return 50 +y*(imageHeight+10);
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0 || section == 1) {
//        return 44;
//    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == infoModel.surgery.count) {
        return 60;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0 || section == 1) {
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
            titlLab.text = @"手术信息";
         
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
//    }else{
//        return nil;
//    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellid = @"cellid";
        PatientsBasicInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PatientsBasicInfoTableViewCell" owner:self options:nil]lastObject];
        }
        [cell.suiFangButton addTarget:self action:@selector(suiFangButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cell.model = infoModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            static NSString *cellid = @"cellId";
            ZJNOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNOperationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[indexPath.section-1]];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *cellid = @"cellID";
            TitleAndImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[TitleAndImageViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[indexPath.section-1]];
            if (indexPath.row == 1) {
                cell.imageArray = model.images;
                cell.titleLabel.text = @"器械合格证";
            }else if  (indexPath.row == 2){
                cell.imageArray = model.imagex;
                cell.titleLabel.text = @"X光片";
            }else if (indexPath.row == 3){
                cell.imageArray = model.video;
                cell.titleLabel.text = @"术后视频";
            }else{
                cell.imageArray = model.imaget;
                cell.titleLabel.text = @"术后体位";
            }
            
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

#pragma mark--titleAndImageViewTableViewCellDelegate
-(void)showImageWithIndex:(NSInteger)index withCell:(TitleAndImageViewTableViewCell *)cell{
    signIndexPath = [_tableView indexPathForCell:cell];

    OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[signIndexPath.section-1]];

    if(signIndexPath.row ==3){
        if (model.video.count < index) {
            return ;
        }
        NSString *localPath = [NSString stringWithFormat:@"%@%@",imgPath, [model.video[index]  objectForKey:@"path"]];
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
    OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[signIndexPath.section-1]];
    if (signIndexPath.row == 1) {
        return model.images.count;
    }else{
        return model.imagex.count;
    }
    
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[signIndexPath.section-1]];
    NSDictionary *dic;
    if (signIndexPath.row == 1) {
        dic = model.images[index];
    }else{
        dic = model.imagex[index];
    }
     NSString * photimageStr  =[NSString stringWithFormat:@"%@",dic[@"path"]];
    if ([photimageStr containsString:imgPath]) {
    }else{
        photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
    }
    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
    

    return photot;
}
#pragma mark--收到通知刷新页面
-(void)refershView{
    [self makeData];
}
#pragma mark--随访记录
-(void)suiFangButtonClick{
    AddFollow_UpRecordsViewController *shu = [[AddFollow_UpRecordsViewController alloc]init];
    shu.status = [NSString stringWithFormat:@"2"];
    shu.infoDic = TwoDic;
    shu.hospitalID = [[NSUserDefaults standardUserDefaults]objectForKey:@"hospitalnumbar"];;
    shu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shu animated:NO];
}
#pragma mark--修改病历
-(void)changeButtonClick:(UIButton *)button{
    OperationInfoModel *model = [OperationInfoModel yy_modelWithDictionary:infoModel.surgery[button.tag-1]];
    ZJNChangeOperationRequestModel *changeModel = [[ZJNChangeOperationRequestModel alloc]initWithOperationModel:model];
    ZJNChangeOperationViewController *view = [[ZJNChangeOperationViewController alloc]init];
    view.requestModel = changeModel;
    
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
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
