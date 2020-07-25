//
//  ZJNChangeCheckResultViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangeCheckResultViewController.h"
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
#import "PingfenModel.h"
#pragma mark--预览图片
#import "MWPhotoBrowser.h"
#pragma mark--选择关节单元格
#import "ZJNScrollTableViewCell.h"
#import "ZhhuanChangViewController.h"
#import "TZImagePickerController.h"
#import "ZJNUploadInvoicesViewController.h"
#define kPadding 10
#define ImageWidth (ScreenWidth - 50)/4
@interface ZJNChangeCheckResultViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNTitleAndTextViewTableViewDelegate,ZJNExpandableTextTableViewDelegate,ZJNGradeTableViewCellDelegate,ZJNChoosePCellDelegate,ChoseViewDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,MWPhotoBrowserDelegate,TZImagePickerControllerDelegate>
{
    UITableView *_tableView;
    CGFloat cellHeight[10];
    NSArray *titleArr;
    NSArray *placeholderArr;
    
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

@implementation ZJNChangeCheckResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者信息";
    cellHeight[0] = MAX(80, self.infoModel.allergyHeight);
    
    cellHeight[1] = 44;
    cellHeight[2] = MAX(44, self.infoModel.chiefHeight);
    cellHeight[3] = MAX(44, self.infoModel.diagnosisHeight);
    cellHeight[4] = MAX(44, self.infoModel.hpiHeight);
    cellHeight[5] = MAX(44, self.infoModel.historyHeight);
    cellHeight[6] = MAX(44, self.infoModel.checkHeight);
    cellHeight[7] = MAX(80, self.infoModel.ecgHeight);
    cellHeight[8] = MAX(80, self.infoModel.imagingHeight);
    cellHeight[9] = 36 * [self.infoModel.forms count];
 
    _cellData = [NSMutableArray arrayWithArray:@[self.infoModel.allergyName,@"",self.infoModel.chief?self.infoModel.chief:@"",self.infoModel.diagnosis,self.infoModel.hpi,self.infoModel.history,self.infoModel.check,self.infoModel.ecgName,self.infoModel.imagingName,@""]];

     titleArr = @[@"药物过敏史",@"关节",@"主诉",@"诊断",@"现病史",@"既往史",@"专科检查",@"心电图检查",@"影像学检查"];
    placeholderArr = @[@"请输入药物过敏史（多行输入）",@"",@"请输入主诉（多行输入）",@"请输入诊断结果（多行输入）",@"请输入现病史病例（多行输入）",@"请输入既往史病例（多行输入）",@"请输入具体异常（多行输入）",@"请输入心电图检查结果（多行输入）",@"请输入影像学检查结果（多行输入）"];
    
    imageArray = [NSMutableArray array];
    for (int a = 0; a < self.infoModel.hzxx.count; a ++) {
        NSString *imgSt = [NSString stringWithFormat:@"%@%@",imgPath,self.infoModel.hzxx[a][@"path"]];
        [imageArray addObject:imgSt];
    }
 
    jointArray = [NSMutableArray array];
    [jointArray addObjectsFromArray:self.infoModel.joints];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
    [nextButton setTitle:@"确定" forState:normal];
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
                if ([self.infoModel.allergy isEqualToString:@"0"]) {
                    cell.rightButton.selected = NO;
                    cell.leftButton.selected = YES;
                    cell.textView.hidden = YES;
                }else{
                    cell.leftButton.selected = NO;
                    cell.rightButton.selected = YES;
                    cell.textView.hidden = NO;
                }
            }else{
                cell.leftLabel.text = @"正常";
                cell.rightLabel.text = @"异常";
                if (indexPath.row == 6) {
                    if ([self.infoModel.ecg isEqualToString:@"0"]) {
                        cell.leftButton.selected = NO;
                        cell.rightButton.selected = YES;
                        cell.textView.hidden = NO;
                    }else{
                        cell.rightButton.selected = NO;
                        cell.leftButton.selected = YES;
                        cell.textView.hidden = YES;
                    }
                }else{
                    if ([self.infoModel.imaging isEqualToString:@"0"]) {
                        cell.leftButton.selected = NO;
                        cell.rightButton.selected = YES;
                        cell.textView.hidden = NO;
                    }else{
                        cell.rightButton.selected = NO;
                        cell.leftButton.selected = YES;
                        cell.textView.hidden = YES;
                    }
                }
            }
            cell.titleLabel.text = titleArr[indexPath.row];;
            cell.text = [self.cellData objectAtIndex:indexPath.row];
            cell.textView.placeholder = placeholderArr[indexPath.row];
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
            cell.PingfenArray = self.infoModel.forms;
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
    
   
    PingfenModel * model =    self.infoModel.forms[index];
    
    harrisPingfenViewController *harr = [[harrisPingfenViewController alloc]init];
    harr.returnValueBlock = ^(NSDictionary *harrisDic) {
        
        model.saveColumn = harrisDic[@"saveColumn"];
        model.saveNumber = harrisDic[@"saveNumber"];
        [self.infoModel.forms replaceObjectAtIndex:index withObject:model];
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
//
//        harr.valStr = [NSString stringWithFormat:@"%@",self.infoModel.harris];
//        harr.pfuid = [NSString stringWithFormat:@"%@",self.infoModel.harrisuid];
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else if ([gradeType isEqualToString:@"hss"]){
//        HssPingfenViewController *harr = [[HssPingfenViewController alloc]init];
//        harr.returnValueHsBlock = ^(NSDictionary *hssDic) {
//            self.infoModel.hss = [NSString stringWithFormat:@"%@",hssDic[@"val"]];
//            self.infoModel.hssuid = [NSString stringWithFormat:@"%@",hssDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr = [NSString stringWithFormat:@"%@",self.infoModel.hss];
//        harr.pfuid = [NSString stringWithFormat:@"%@",self.infoModel.hssuid];
//
//        harr.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:harr animated:NO];
//    }else{
//        SfPingfenViewController *harr = [[SfPingfenViewController alloc]init];
//        harr.returnValueSfBlock = ^(NSDictionary *sfValueDic) {
//            self.infoModel.sf = [NSString stringWithFormat:@"%@",sfValueDic[@"val"]];
//            self.infoModel.sfuid = [NSString stringWithFormat:@"%@",sfValueDic[@"pfuid"]];
//            [_tableView reloadData];
//        };
//        harr.valStr =[NSString stringWithFormat:@"%@",self.infoModel.sf];
//        harr.pfuid = [NSString stringWithFormat:@"%@",self.infoModel.sfuid];
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

    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
    
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
    self.infoModel.chief = _cellData[2];
    self.infoModel.diagnosis = _cellData[3];
    self.infoModel.hpi = _cellData[4];
    self.infoModel.history = _cellData[5];
    self.infoModel.check = _cellData[6];
    self.infoModel.ecgName = _cellData[7];
    self.infoModel.imagingName = _cellData[8];
    
    NSString *imageStr;
    if (imageArray.count>0) {
        imageStr = [imageArray componentsJoinedByString:@","];
    }else{
        imageStr = @"";
    }
   
    imageStr =[imageStr stringByReplacingOccurrencesOfString:imgPath withString:@""];
 
//    self.infoModel.hzxx = imageStr;
    NSString * formsStr;
    if ( self.infoModel.forms.count > 0) {
        NSMutableArray * formsArray  = [[NSMutableArray alloc]init];
        for (PingfenModel * models in  self.infoModel.forms) {
            NSString * str = [NSString stringWithFormat:@"%@|%@|%@",models.formId,models.saveNumber,models.saveColumn];
            [formsArray addObject:str];
        }
        
        formsStr =[formsArray componentsJoinedByString:@","];
     }
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",requestUrl,updatehzxx];
    NSArray *keysArr = @[@"sessionId",@"hospnumId",@"chief",@"check",@"harris",@"hss",@"sf",@"allergy",@"allergyName",@"diagnosis",@"ecg",@"ecgName",@"imaging",@"imagingName",@"hpi",@"history",@"joints",@"harrisuid",@"hssuid",@"sfuid",@"forms",@"hzxx"];
    NSArray *valuesArr = @[self.infoModel.sessionId,self.infoModel.hospnumId,self.infoModel.chief,self.infoModel.check,@"",@"",@"",self.infoModel.allergy,self.infoModel.allergyName,self.infoModel.diagnosis,self.infoModel.ecg,self.infoModel.ecgName,self.infoModel.imaging,self.infoModel.imagingName,self.infoModel.hpi, self.infoModel.history,jointStr,@"",@"",@"",formsStr?formsStr:@"",imageStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
   

    [ZJNRequestManager postWithUrlString:urlStr parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            if (self.refreshMedicalRecord) {
                self.refreshMedicalRecord();
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
        [self showHint:data[@"message"]];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self showHint:@"修改失败"];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
