//
//  ZJNUploadInvoicesViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNUploadInvoicesViewController.h"
#import "ZJNChoosePicturesTableViewCell.h"
#import "PhotoChoseView.h"
#import "MWPhotoBrowser.h"
#import "ZYQAssetPickerController.h"
#import "TZImagePickerController.h"
#import "AFNetworking.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "uploadModel.h"
#define VIDEOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoCache"]
#define kPadding 10
#define imageWidth (ScreenWidth-50)/4.0
#import "PingfenModel.h"
@interface ZJNUploadInvoicesViewController ()<UITableViewDelegate,UITableViewDataSource,ZJNChoosePCellDelegate,MWPhotoBrowserDelegate,ChoseViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    UITableView *_tableView;
    MWPhotoBrowser *browser;
    UIView *_backWindowView;
    PhotoChoseView *_ChoseView;
    UIImagePickerController *imgPicker;
    NSIndexPath *signIndexPath;
    
    NSMutableArray *HYArr;
    NSMutableArray *XArr;
    NSMutableArray *TWArr;
    NSMutableArray *BTArr;//步态视频上传后返回的地址（需要再传给服务器）
    NSMutableArray *BTImageArr;//步态视频上传后获取视频第一帧图片（用于展示）
    
}
@property (nonatomic ,strong)NSMutableArray *uploadArray;
@end

@implementation ZJNUploadInvoicesViewController

-(instancetype)initWithUploadInvoicesType:(UploadInvoicesType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"上传单据";
    HYArr = [NSMutableArray array];
    XArr  = [NSMutableArray array];
    TWArr = [NSMutableArray array];
    BTArr = [NSMutableArray array];
    [HYArr addObjectsFromArray:self.hyArr];
    [XArr addObjectsFromArray:self.xgArr];
    [TWArr addObjectsFromArray:self.twArr];
    [BTArr addObjectsFromArray:self.videoArr];
    BTImageArr = [NSMutableArray array];
   
 
   
   
    
    _uploadArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //    子线程处理 视频第一帧图片
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        for (NSString * vodieStr in BTArr) {
            NSString *pathss = [NSString stringWithFormat:@"%@%@",imgPath,vodieStr];
            NSURL * url = [NSURL URLWithString:pathss];
            [BTImageArr addObject:[Utile imageWithMediaURL:url]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            
        });
    });

    // Do any additional setup after loading the view.
}
#pragma mark--UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 140;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSInteger y;
        NSInteger x;
        if (HYArr.count<16) {
            y = (HYArr.count+1)/4;
            x = (HYArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (HYArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else if (indexPath.section == 1){
        NSInteger y;
        NSInteger x;
        if (XArr.count<16) {
            y = (XArr.count+1)/4;
            x = (XArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (XArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else if (indexPath.section == 2){
        NSInteger y;
        NSInteger x;
        if (TWArr.count<16) {
            y = (TWArr.count+1)/4;
            x = (TWArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (TWArr.count)/4;
        }
        return kPadding+y*(kPadding+imageWidth);
    }else{
        NSInteger y;
        NSInteger x;
        if (BTArr.count<16) {
           y = (BTArr.count+1)/4;
           x = (BTArr.count+1)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }else{
            y = (BTArr.count)/4;
            x = (BTArr.count)%4;
            if (x >0 || y == 0) {
                y += 1;
            }
        }
        
        return kPadding+y*(kPadding+imageWidth);
    }
    
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
        titlLab.text = @"化验单";
    }else if (section == 1){
        titlLab.text = @"X光照";
    }else if (section == 2){
        titlLab.text = @"体位照";
    }else{
        titlLab.text = @"步态小视频";
    }
    return heardView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(30, 60, ScreenWidth-60, 44);
        nextButton.backgroundColor = greenC;
        [Utile makeCorner:22 view:nextButton];
        [nextButton setTitle:@"提交" forState:normal];
        nextButton.titleLabel.font = Font14;
        [nextButton setTitleColor:[UIColor whiteColor] forState:normal];
        [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:nextButton];
        return footerView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellID";
    ZJNChoosePicturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZJNChoosePicturesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.imageArray = HYArr;
    }else if (indexPath.section == 1){
        cell.imageArray = XArr;
    }else if (indexPath.section == 2){
        cell.imageArray = TWArr;
    }else{
        cell.imageArray = BTImageArr;
    }
    return cell;
}
#pragma mark--ZJNChoosePCellDelegate
/*
 * 添加图片
 */
-(void)choosePicturesTableViewCellAddPicturesWithCell:(ZJNChoosePicturesTableViewCell *)cell{
    signIndexPath = [_tableView indexPathForCell:cell];
    if (signIndexPath.section == 3) {
        [self selectVideo];
    }else{
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
}
/*
 * 预览图片
 */
-(void)choosePicturesTableViewCellPreviewPictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell{
    signIndexPath = [_tableView indexPathForCell:cell];
    if (signIndexPath.section == 3) {
        
    }else{
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
}
/*
 * 删除图片
 */
-(void)choosePicturesTableViewCellDeletePictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell{
    signIndexPath = [_tableView indexPathForCell:cell];
    if (signIndexPath.section == 0) {
        [HYArr removeObjectAtIndex:index];
    }else if (signIndexPath.section == 1){
        [XArr removeObjectAtIndex:index];
    }else if (signIndexPath.section == 2){
        [TWArr removeObjectAtIndex:index];
    }else{
        [BTArr removeObjectAtIndex:index];
        [BTImageArr removeObjectAtIndex:index];
    }
    
    [_tableView reloadData];
}
#pragma mark--MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    if (signIndexPath.section == 0) {
        return HYArr.count;
    }else if (signIndexPath.section == 1){
        return XArr.count;
    }else if (signIndexPath.section == 2){
        return TWArr.count;
    }else{
        return BTArr.count;
    }
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photot;
    
    
    
    if (signIndexPath.section == 0) {
        NSString * photimageStr  =[NSString stringWithFormat:@"%@",HYArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
        photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
 
    }else if (signIndexPath.section == 1){
        NSString * photimageStr  =[NSString stringWithFormat:@"%@",XArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
        photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];

       
    }else if (signIndexPath.section == 2){
        NSString * photimageStr  =[NSString stringWithFormat:@"%@",TWArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
        photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
 
    }else{
        NSString * photimageStr  =[NSString stringWithFormat:@"%@",BTArr[index]];
        if ([photimageStr containsString:imgPath]) {
        }else{
            photimageStr = [NSString stringWithFormat:@"%@%@",imgPath,photimageStr];
        }
         photot = [MWPhoto photoWithURL:[NSURL URLWithString:photimageStr]];
 
    }
    return photot;
}
#pragma mark--ChoseViewDelegate
// 从系统相册选择按钮
- (void)makeSelectBtnOne{
    
    TZImagePickerController *tzController = [[TZImagePickerController alloc]initWithMaxImagesCount:16 delegate:self];
    if (signIndexPath.section == 0) {
        tzController.maxImagesCount = 16 - HYArr.count;
    }else if (signIndexPath.section == 1){
        tzController.maxImagesCount = 16 - XArr.count;
    }else if (signIndexPath.section == 2){
        tzController.maxImagesCount = 16 - TWArr.count;
    }else{
        tzController.maxImagesCount = 16 - BTArr.count;
    }
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //获取用户选择或拍摄的是照片还是视频
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
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
        [self.uploadArray addObject:model];
        
        [self uploadImageAndMovieBaseModel:model];
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
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

//上传图片和视频
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
            [BTArr addObject:dica[@"filepath"]];
        }
        NSString *pathss = [NSString stringWithFormat:@"%@%@",imgPath,dica[@"filepath"]];
        NSURL * url = [NSURL URLWithString:pathss];
//        UIImage * imageing = [Utile imageWithMediaURL:url];
        [BTImageArr addObject:[Utile imageWithMediaURL:url]];
        [_tableView reloadData];
        [self hideHud];
        model.isUploaded = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        NSLog(@"上传失败: %@", error);
        model.isUploaded = NO;
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
            if (signIndexPath.section == 0) {
                [HYArr addObjectsFromArray:data[@"data"]];
            }else if (signIndexPath.section == 1){
                [XArr addObjectsFromArray:data[@"data"]];
            }else if (signIndexPath.section == 2){
                [TWArr addObjectsFromArray:data[@"data"]];
            }
        }
        [_tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self hideHud];
    }];
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
#pragma mark--提交按钮点击
-(void)nextButtonClick:(UIButton *)button{
    
    NSString *hyStr = @"";
    NSString *xStr  = @"";
    NSString *twStr = @"";
    NSString *btStr = @"";
    if (HYArr.count>0) {
        hyStr = [HYArr componentsJoinedByString:@","];
    }
    if (XArr.count>0) {
        xStr = [XArr componentsJoinedByString:@","];
    }
    if (TWArr.count>0) {
        twStr = [TWArr componentsJoinedByString:@","];
    }
    if (BTArr.count>0) {
        btStr = [BTArr componentsJoinedByString:@","];
    }
    if (_type == 0) {
        self.infoModel.hy = hyStr;
        self.infoModel.xg = xStr;
        self.infoModel.tw = twStr;
        self.infoModel.video = btStr;
        self.infoModel.status = @"1";
        self.infoModel.sessionid = sessionIding;
/*
        [infoDic setObject:@"" forKey:@"patientId"];
        [infoDic setObject:@"" forKey:@"hospnumId"];
 */
        NSDictionary *dic = [self returnToDictionaryWithModel:self.infoModel];
       
        NSLog(@"%@",dic);
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientpatient_save];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            NSLog(@"添加患者%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                UIViewController *view = self.navigationController.viewControllers[1];
                [self.navigationController popToViewController:view animated:NO];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationAddHuanZhe" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"MainViewController" object:nil];
            }else{
                
            }
            [self showHint:data[@"message"]];
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"添加患者%@",error);
        }];
    }else if(_type == 1){
        [self.fInfoDic setObject:hyStr forKey:@"hy"];
        [self.fInfoDic setObject:xStr forKey:@"xg"];
        [self.fInfoDic setObject:twStr forKey:@"tw"];
        [self.fInfoDic setObject:btStr forKey:@"video"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,patientcall_save];
        
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:self.fInfoDic success:^(id data) {
            NSLog(@"添加回访记录%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                [self showHint:data[@"message"]];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPatientInfo" object:nil];
                NSInteger count = self.navigationController.viewControllers.count-3;
                UIViewController *viewC = self.navigationController.viewControllers[count];
                [self.navigationController popToViewController:viewC animated:NO];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"MainViewController" object:nil];
            }else{
                [self showHint:data[@"message"]];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"添加回访记录%@",error);
        }];
    }else if(_type == 4){
//        修改记录里面的图片
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,updateUpdateimage];
        NSArray *keysArray = @[@"sessionId",@"hospnumId",@"hy",@"tw",@"xg",@"video"];
        NSArray *valueArray = @[sessionIding,self.checkID,hyStr,twStr,xStr,btStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0000"]) {
                if(self.reloadDataBlock){
                    self.reloadDataBlock();
                }
                [self.navigationController popViewControllerAnimated:NO]  ;
                
            }else{
                [self showHint:data[@"message"]];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }else{
        //修改随访里面的病例报告
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,updatecheckimage];
        NSArray *keysArray = @[@"sessionId",@"checkId",@"hy",@"tw",@"xg",@"video"];
        NSArray *valueArray = @[sessionIding,self.checkID,hyStr,twStr,xStr,btStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0000"]) {
                [self.navigationController popViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPatientInfo" object:nil];
            }else{
                [self showHint:data[@"message"]];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
}
-(NSMutableDictionary *)returnToDictionaryWithModel:(ZJNAddPatientRequestModel *)model
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([ZJNAddPatientRequestModel class], &count);
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
    
    if (model.forms.count > 0) {
        NSMutableArray * formsArray  = [[NSMutableArray alloc]init];
        for (PingfenModel * models in model.forms) {
            NSString * str = [NSString stringWithFormat:@"%@#%@#%@",models.formId,models.saveNumber,models.saveColumn];
            if (models.saveNumber.length > 0 && ![models.saveNumber isEqualToString:@"(null)"]) {
                [formsArray addObject:str];
            }
        }
        
        NSString * formsStr =[formsArray componentsJoinedByString:@","];
        [userDic setObject:formsStr forKey:@"forms"];
    }
    
    return userDic;
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
