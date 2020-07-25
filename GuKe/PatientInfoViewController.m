//
//  PatientInfoViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "PatientInfoViewController.h"
#pragma mark--textView高度自适应
#import "ZJNTitleAndTextViewTableViewCell.h"
#import "ZJNExpandableTextTableViewCell.h"
#pragma mark--评分单元格
#import "ZJNGradeTableViewCell.h"
#pragma mark--评分页面
#import "harrisPingfenViewController.h"
#import "HssPingfenViewController.h"
#import "SfPingfenViewController.h"
#pragma mark--选择图片
#import "ZJNChoosePicturesTableViewCell.h"
#import "ZYQAssetPickerController.h"
#import "PhotoChoseView.h"
#pragma mark--预览图片
#import "MWPhotoBrowser.h"
#pragma mark--选择关节单元格
#import "ZJNScrollTableViewCell.h"
#import "ZhhuanChangViewController.h"
#import "TZImagePickerController.h"
//#import "DanJuViewController.h"
#import "ZJNUploadInvoicesViewController.h"
#define kPadding 10
#define ImageWidth (ScreenWidth - 50)/4
#import "PingfenModel.h"
@interface PatientInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNTitleAndTextViewTableViewDelegate,ZJNExpandableTextTableViewDelegate,ZJNGradeTableViewCellDelegate,ZJNChoosePCellDelegate,ChoseViewDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,TZImagePickerControllerDelegate>
{
    UITableView *_tableView;
    CGFloat cellHeight[10];
    NSArray *titleArr;
    NSArray *placeholderArr;
    /*
    NSString *allergy;//药物过敏史（有无）
    NSString *allergyName;//药物过敏史（过敏药物）
    
    NSString *diagnosis;//诊断结果
    NSString *history;//既往史
    NSString *check;//专科检查
    
    NSString *ecg;//心电图（有无）
    NSString *ecgName;//心电图（检查结果）
    
    NSString *imaging;//影像学检查（有无）
    NSString *imagingName;//影像学（检查结果）
    
    NSString *harrisStr;//harris评分
    NSString *HSSStr;//HSS评分
    NSString *SF_12Str;//SF-12评分
    */
    NSMutableArray * pingfenArray; // 评分的个数；
    NSMutableArray *imageArray;//图片数组
    NSMutableArray *jointArray;//关节数组
    
    UIView         *_backWindowView;//黑色背景
    UIImagePickerController *imgPicker;
    MWPhotoBrowser *browser;
    
    ZJNUploadInvoicesViewController *uploadInvoicesView;
}
@property (nonatomic ,strong)NSMutableArray *cellData;
@property (nonatomic ,strong)PhotoChoseView *ChoseView;
@end

@implementation PatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pingfenArray = [[NSMutableArray alloc]init];
    self.title = @"患者信息";
    cellHeight[0] = 80;
    cellHeight[1] = 44;
    cellHeight[2] = 44;
    cellHeight[3] = 44;
    cellHeight[4] = 44;
    cellHeight[5] = 44;
    cellHeight[6] = 44;
    cellHeight[7] = 80;
    cellHeight[8] = 80;
    cellHeight[9] = 115;
    _cellData = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    titleArr = @[@"药物过敏史",@"关节",@"主诉",@"诊断",@"现病史",@"既往史",@"专科检查",@"心电图检查",@"影像学检查"];
    placeholderArr = @[@"请输入药物过敏史（多行输入）",@"",@"请输入主诉（多行输入）",@"请输入诊断结果（多行输入）",@"请输入现病史病例（多行输入）",@"请输入既往史病例（多行输入）",@"请输入具体异常（多行输入）",@"请输入心电图检查结果（多行输入）",@"请输入影像学检查结果（多行输入）"];
    /*
    harrisStr = @"";
    HSSStr    = @"";
    SF_12Str  = @"";
    allergy   = @"0";
    ecg       = @"1";
    imaging   = @"1";
     */
    self.infoModel.allergy = @"0";
    self.infoModel.ecg = @"1";
    self.infoModel.imaging = @"1";
    
    imageArray = [NSMutableArray array];
    jointArray = [NSMutableArray array];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self  makePingData];
    // Do any additional setup after loading the view.
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 140;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0||indexPath.row == 7||indexPath.row == 8) {
            return MAX(80, cellHeight[indexPath.row]);
        }
        return MAX(44, cellHeight[indexPath.row]);
    }else{
        
        NSInteger y;
        NSInteger x;
        if (imageArray.count<16) {
            y = (imageArray.count+1)/4;
            x = (imageArray.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (imageArray.count)/4;
        }
        
        return kPadding+y*(kPadding+ImageWidth);
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    UIImageView * greenImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 2, 16)];
    greenImg.image = [UIImage imageNamed:@"矩形-6"];
    [heardView addSubview:greenImg];
    
    UILabel *titlLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenImg.frame)+ 10, 0, 60, 44)];
    titlLab.font = Font14;
    titlLab.textColor = SetColor(0x1a1a1a);
    [heardView addSubview:titlLab];
    
    if (section == 0) {
        titlLab.text = @"检查记录";
    }else{
        titlLab.text = @"上传图片";
        
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlLab.frame)+ 5, 15, 18, 16)];
        images.image = [UIImage imageNamed:@"上传图片123"];
        [heardView addSubview:images];
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0||indexPath.row == 7||indexPath.row == 8) {
            static NSString *cellid = @"celliD";
            ZJNExpandableTextTableViewCell *cell = [tableView expandableTextCellWithId:cellid];
            if (!cell) {
                cell = [[ZJNExpandableTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"无";
                cell.rightLabel.text = @"有";
            }else{
                cell.leftLabel.text = @"正常";
                cell.rightLabel.text = @"异常";
            }
            cell.titleLabel.text = titleArr[indexPath.row];;
            cell.text = [self.cellData objectAtIndex:indexPath.row];
            cell.textView.placeholder = placeholderArr[indexPath.row];;
            cell.textView.font = Font14;
            cell.textView.textAlignment = NSTextAlignmentLeft;
            return cell;

        }else if (indexPath.row == 1){
            static NSString *cellid = @"cellID";
            ZJNScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNScrollTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"关节";
            cell.typeArray = jointArray;
            UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
            [cell.scrollView addGestureRecognizer:tap];

            return cell;
        }else if (indexPath.row == 9){
            static NSString *cellid = @"celLID";
            ZJNGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNGradeTableViewCell" owner:self options:nil]lastObject];
            }
//            cell.harrisString = self.infoModel.harris;
//            cell.HSSString = self.infoModel.hss;
//            cell.SF_12String = self.infoModel.sf;
            cell.PingfenArray = pingfenArray;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else{
            static NSString *cellid = @"ceLLID";
            ZJNTitleAndTextViewTableViewCell *cell = [tableView expandableTitleAndTextViewTextCellWithId:cellid];
            if (!cell) {
                cell = [[ZJNTitleAndTextViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.titleLabel.text = titleArr[indexPath.row];
            cell.text = [self.cellData objectAtIndex:indexPath.row];
            cell.textView.placeholder = placeholderArr[indexPath.row];
            cell.textView.textAlignment = NSTextAlignmentLeft;
            return cell;
        }
    }else{
        static NSString *cellid = @"cELLId";
        ZJNChoosePicturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNChoosePicturesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.imageArray = imageArray;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self selectTap];
    }
}
-(void)selectTap{
    ZhhuanChangViewController *zhuan = [[ZhhuanChangViewController alloc]init];
    zhuan.typeStr = @"1";
    zhuan.returnZhuan = ^(NSMutableArray *arr){
        [jointArray removeAllObjects];
        [jointArray addObjectsFromArray:arr];
        [_tableView reloadData];
    };
    zhuan.selectArray = jointArray;
    zhuan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhuan animated:NO];
}
#pragma mark--ZJNTitleAndTextViewTableViewDelegate
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath{
    [self.cellData replaceObjectAtIndex:indexPath.row withObject:text];
}
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath{
    cellHeight[indexPath.row] = height;
}

#pragma mark--ZJNExpandableTextTableViewDelegate
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    cellHeight[indexPath.row] = height;
}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    [self.cellData replaceObjectAtIndex:indexPath.row withObject:text];
}
-(void)tableView:(UITableView *)tableView singleButtonSelect:(NSString *)type atIndexPath:(NSIndexPath *)indexPath{
    //左边按钮是0  右边按钮是1
    if (indexPath.row == 0) {
        self.infoModel.allergy = type;
    }else if (indexPath.row == 7){
        if ([type isEqualToString:@"0"]) {
            self.infoModel.ecg = @"1";
        }else{
            self.infoModel.ecg = @"0";
        }
        
    }else if (indexPath.row == 8){
        if ([type isEqualToString:@"0"]) {
            self.infoModel.imaging = @"1";
        }else{
            self.infoModel.imaging = @"0";
        }
    }
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

    
//    if ([gradeType isEqualToString:@"harris"]) {
//        harrisPingfenViewController *harr = [[harrisPingfenViewController alloc]init];
//        harr.returnValueBlock = ^(NSDictionary *harrisDic) {
//            self.infoModel.harris = [NSString stringWithFormat:@"%@",harrisDic[@"val"]];
//            self.infoModel.harrisuid = [NSString stringWithFormat:@"%@",harrisDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr = self.infoModel.harris;
//        harr.pfuid = self.infoModel.harrisuid;
//
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else if ([gradeType isEqualToString:@"hss"]){
//        HssPingfenViewController *harr = [[HssPingfenViewController alloc]init];
//        harr.returnValueHsBlock = ^(NSDictionary *hssDic) {
//            self.infoModel.hss = [NSString stringWithFormat:@"%@",hssDic[@"val"]];
//            self.infoModel.hssuid = [NSString stringWithFormat:@"%@",hssDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr = self.infoModel.hss;
//        harr.pfuid = self.infoModel.hssuid;
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else{
//        SfPingfenViewController *harr = [[SfPingfenViewController alloc]init];
//        harr.returnValueSfBlock = ^(NSDictionary *sfValueDic) {
//            self.infoModel.sf = [NSString stringWithFormat:@"%@",sfValueDic[@"val"]];
//            self.infoModel.sfuid = [NSString stringWithFormat:@"%@",sfValueDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr = self.infoModel.sf;
//        harr.pfuid = self.infoModel.sfuid;
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }
}
#pragma mark--ZJNChoosePCellDelegate
/*
 * 添加图片
 */
-(void)choosePicturesTableViewCellAddPicturesWithCell:(ZJNChoosePicturesTableViewCell *)cell{
    NSLog(@"添加图片");
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
#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return imageArray.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
     NSString * photimageStr  =[NSString stringWithFormat:@"%@",imageArray[index]];
    if ([photimageStr containsString:imgPath]) {
    }else{
        photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
    }
    photimageStr = [photimageStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"imgs"];

    MWPhoto *photot  = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
    return photot;
}
/*
 * 删除图片
 */
-(void)choosePicturesTableViewCellDeletePictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell{
    [imageArray removeObjectAtIndex:index];
    [_tableView reloadData];
}
#pragma mark--跳转到下个页面
-(void)nextButtonClick:(UIButton *)button{
    
    self.infoModel.allergyName = _cellData[0];
    NSString *jointStr;
    if (jointArray.count>0) {
        for (int i = 0; i <jointArray.count; i ++) {
            NSDictionary *dic = jointArray[i];
            if (i == 0) {
                jointStr = dic[@"uid"];
            }else{
                jointStr = [NSString stringWithFormat:@"%@,%@",jointStr,dic[@"uid"]];
            }
        }
    }else{
        jointStr = @"";
    }
    self.infoModel.joints = jointStr;
    self.infoModel.chief = _cellData[2];

    self.infoModel.diagnosis = _cellData[3];
    self.infoModel.hpi = _cellData[4];
    self.infoModel.history = _cellData[5];
    self.infoModel.checks = _cellData[6];
    self.infoModel.ecgName = _cellData[7];
    self.infoModel.imagingName = _cellData[8];
    self.infoModel.forms = pingfenArray;
    NSString *imageStr;
    if (imageArray.count>0) {
        imageStr = [imageArray componentsJoinedByString:@","];
    }else{
        imageStr = @"";
    }
    self.infoModel.hzxx = imageStr;
    
    if (!uploadInvoicesView) {
        uploadInvoicesView = [[ZJNUploadInvoicesViewController alloc]initWithUploadInvoicesType:UploadInvoicesFromAddPatient];
    }
    uploadInvoicesView.infoModel = self.infoModel;
    uploadInvoicesView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:uploadInvoicesView animated:NO];
}

/*******************************************************************/

#pragma 从系统相册选择按钮
- (void)makeSelectBtnOne{
    
    TZImagePickerController *tzController = [[TZImagePickerController alloc]initWithMaxImagesCount:16-imageArray.count delegate:self];
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

#pragma 拍照按钮
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
        [self.ChoseView removeFromSuperview];
        self.ChoseView = nil;
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
            [imageArray addObjectsFromArray:data[@"data"]];
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
#pragma 取消按钮
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makePingData{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,form_list];
     NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
         NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        NSLog(@"%@",data);
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            for(NSDictionary * dic in array){
                PingfenModel *model = [PingfenModel yy_modelWithJSON:dic];
                [pingfenArray addObject:model];
            }
            cellHeight[9] = 36 * pingfenArray.count;

             [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
            
        
    } failure:^(NSError *error) {
    
    }];
 
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
