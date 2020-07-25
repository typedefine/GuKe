//
//  ZJNChangeBodyInfoViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangeBodyInfoViewController.h"
#import "ZJNPatientBodyInfoTableViewCell.h"
#import "ZJNChoosePicturesTableViewCell.h"
#import "ZYQAssetPickerController.h"
#import "PatientInfoViewController.h"
#import "PhotoChoseView.h"
#import "MWPhotoBrowser.h"
#import "TZImagePickerController.h"
#define kPadding 10
#define imageWidth (ScreenWidth-50)/4.0
@interface ZJNChangeBodyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNChoosePCellDelegate,ChoseViewDelegate,MWPhotoBrowserDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,ZJNPatientBodyInfoDelegate,TZImagePickerControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *imageArr;
    MWPhotoBrowser *browser;
    UIView *_backWindowView;
    PhotoChoseView *_ChoseView;
    UIImagePickerController *imgPicker;
    PatientInfoViewController *patientInfoview;
    
    NSString *highBP;
    NSString *lowBP;
    
}

@end

@implementation ZJNChangeBodyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"体征信息";
    [self initInfoStr];
    imageArr = [NSMutableArray array];
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
        return 200;
    }
    
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
        titlLab.text = @"生命体征";
    }else{
        titlLab.text = @"上传图片";
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titlLab.frame)+ 5, 15, 18, 16)];
        images.image = [UIImage imageNamed:@"上传图片123"];
        [heardView addSubview:images];
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
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
    }else{
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellid = @"cellid";
        ZJNPatientBodyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNPatientBodyInfoTableViewCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        cell.tiWenTextField.text = self.infoModel.temperature;
        cell.pulseTextField.text = self.infoModel.pulse;
        cell.breatheTextField.text = self.infoModel.breathe;
        cell.hightBloodPressureTextField.text = highBP;
        cell.lowBloodPressureTextField.text = lowBP;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellid = @"cellID";
        ZJNChoosePicturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNChoosePicturesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageArray = imageArr;
        return cell;
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
    MWPhoto *photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];

    return photot;
}
#pragma mark--ChoseViewDelegate
// 从系统相册选择按钮
- (void)makeSelectBtnOne{
    
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
#pragma mark--ZJNPatientBodyInfoDelegate
-(void)zjnPatientBodyInfoTextDieldEndEditingWithDictionary:(NSDictionary *)dic{
    NSString *str = dic[@"type"];
    if ([str isEqualToString:@"0"]) {
        self.infoModel.temperature = dic[@"text"];
    }else if ([str isEqualToString:@"1"]){
        self.infoModel.pulse = dic[@"text"];
    }else if ([str isEqualToString:@"2"]){
        self.infoModel.breathe = dic[@"text"];
    }else if ([str isEqualToString:@"3"]){
        highBP = dic[@"text"];
    }else{
        lowBP = dic[@"text"];
    }
}
#pragma mark--跳转到下一级页面
-(void)nextButtonClick:(UIButton *)button{
    
    self.infoModel.pressure = [NSString stringWithFormat:@"%@,%@",highBP,lowBP];
    if (imageArr.count>0) {
        self.infoModel.tzxx = [imageArr componentsJoinedByString:@","];
    }
    
}
-(void)initInfoStr{
    
    highBP = @"";
    lowBP = @"";
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
