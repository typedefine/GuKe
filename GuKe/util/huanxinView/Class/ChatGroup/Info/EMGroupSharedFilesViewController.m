//
//  EMGroupSharedFilesViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/4/26.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "EMGroupSharedFilesViewController.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EMMemberCell.h"
#import "ICouldManager.h"
#import "ViewFileController.h"
#import "GuKeNavigationViewController.h"

@interface EMGroupSharedFilesViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) EMGroup *group;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation EMGroupSharedFilesViewController

- (instancetype)initWithGroup:(EMGroup *)aGroup
{
    self = [super init];
    if (self) {
        self.group = aGroup;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"group.sharedfiles", @"Share File");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UpdateGroupSharedFile" object:nil];
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"backanniu"] forState:UIControlStateNormal];
//    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    [uploadButton setTitle:NSLocalizedString(@"group.upload", @"Upload") forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *uploadItem = [[UIBarButtonItem alloc] initWithCustomView:uploadButton];
    [self.navigationItem setRightBarButtonItem:uploadItem];
    
    self.showRefreshHeader = YES;
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMemberCell *cell = (EMMemberCell *)[tableView dequeueReusableCellWithIdentifier:@"EMMemberCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EMMemberCell" owner:self options:nil] lastObject];
        
        cell.showAccessoryViewInDelete = YES;
    }
    
    EMGroupSharedFile *file = [self.dataArray objectAtIndex:indexPath.row];
    cell.leftLabel.text = file.fileName;
    if (file.fileName.length == 0) {
        cell.leftLabel.text = file.fileId;
    }
    cell.rightLabel.text = [NSString stringWithFormat:@"%.2lf MB",(float)file.fileSize/(1024*1024)];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setupCellEditActions:indexPath];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self setupCellEditActions:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMGroupSharedFile *file = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *filePath = NSHomeDirectory();
    filePath = [NSString stringWithFormat:@"%@/Library/appdata/download",filePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath]) {
        [fm createDirectoryAtPath:filePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    NSString *fileName = file.fileName.length > 0 ? file.fileName : file.fileId;
    filePath = [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    
    if ([fm fileExistsAtPath:filePath]) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop];
        [self presentViewController:activityVC animated:YES completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        [self showHudInView:self.view hint:NSLocalizedString(@"group.download", @"Downloading ...")];
        [[EMClient sharedClient].groupManager downloadGroupSharedFileWithId:_group.groupId filePath:filePath sharedFileId:file.fileId progress:^(int progress) {
            // NSLog(@"%d",progress);
        } completion:^(EMGroup *aGroup, EMError *aError) {
            [weakSelf hideHud];
            if (aError) {
                [weakSelf showHint:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"group.downloadFail", @"fail to download share file"), aError.errorDescription]];
            }
        }];
    }
}


#pragma mark - private

- (void)deleteCellAction:(NSIndexPath *)aIndexPath
{
    EMGroupSharedFile *file = [self.dataArray objectAtIndex:aIndexPath.row];
    
    [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        weakSelf.group = [[EMClient sharedClient].groupManager removeGroupSharedFileWithId:weakSelf.group.groupId sharedFileId:file.fileId error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                [weakSelf.dataArray removeObject:file];
                [weakSelf.tableView reloadData];
            }
            else {
                [weakSelf showHint:error.errorDescription];
            }
        });
    });
}

- (id)setupCellEditActions:(NSIndexPath *)aIndexPath
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"group.remove", @"Remove") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self deleteCellAction:indexPath];
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        return @[deleteAction];
    } else {
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:NSLocalizedString(@"group.remove", @"Remove") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self deleteCellAction:aIndexPath];
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        config.performsFirstActionWithFullSwipe = NO;
        return config;
    }
}

- (void)_uploadData:(NSData *)data filename:(NSString *)filename
{
    NSString *filePath = NSHomeDirectory();
    filePath = [NSString stringWithFormat:@"%@/Library/appdata/files",filePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:filePath]) {
        [fm createDirectoryAtPath:filePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    if (filename.length > 0) {
        filePath = [NSString stringWithFormat:@"%@/%d%@", filePath, (int)[[NSDate date] timeIntervalSince1970], filename];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%d%d.jpg", filePath, (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
    }
    
    [data writeToFile:filePath atomically:YES];
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.uploading", @"Uploading...")];
    [[EMClient sharedClient].groupManager uploadGroupSharedFileWithId:_group.groupId filePath:filePath progress:^(int progress){
        // NSLog(@"%d",progress);
    } completion:^(EMGroupSharedFile *aSharedFile, EMError *aError) {
        [weakSelf hideHud];
        if (!aError) {
            [weakSelf.dataArray insertObject:aSharedFile atIndex:0];
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf showHint:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"setting.uploadFail", @"Failed to upload"), aError.errorDescription]];
        }
    }];
}

#pragma mark - 上传

- (void)uploadAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePicAction];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf photoAction];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectUploadFileFromICouldDrive];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)photoAction
{
    // Pop image picker
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie, (NSString *)kUTTypeVideo, (NSString *)kUTTypeMPEG2Video, (NSString *)kUTTypeAppleProtectedMPEG4Video];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
}

- (void)takePicAction
{
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSEaseLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
#endif
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self _convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        NSData *fileData = [NSData dataWithContentsOfURL:mp4];
        [self _uploadData:fileData filename:@".mp4"];
        
    }else{
        
        NSURL *url = info[UIImagePickerControllerReferenceURL];
        if (url == nil) {
            UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
            NSData *data = UIImageJPEGRepresentation(orgImage, proportion);
            [self _uploadData:data filename:nil];
        } else {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0f) {
                PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset *asset , NSUInteger idx, BOOL *stop){
                    if (asset) {
                        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *data, NSString *uti, UIImageOrientation orientation, NSDictionary *dic){
                            if (data != nil) {
                                NSURL *path = [dic objectForKey:@"PHImageFileURLKey"];
                                NSString *fileName = nil;
                                if (path) {
                                    fileName = [[path absoluteString] lastPathComponent];
                                }
                                [self _uploadData:data filename:fileName];
                            } else {
                                [self showHint:NSEaseLocalizedString(@"message.smallerImage", @"The image size is too large, please choose another one")];
                            }
                        }];
                    }
                }];
            } else {
                ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
                [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                        Byte* buffer = (Byte*)malloc((size_t)[assetRepresentation size]);
                        NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:(NSUInteger)[assetRepresentation size] error:nil];
                        NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                        [self _uploadData:fileData filename:nil];
                    }
                } failureBlock:NULL];
            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}

/*!
 @method
 @brief mov格式视频转换为MP4格式
 @discussion
 @param movUrl   mov视频路径
 @result  MP4格式视频路径
 */
- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [EMCDDeviceManager dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
}



#pragma mark - uploadfile

- (void)selectUploadFileFromICouldDrive
{
    NSArray *documentTypes = @[
        @"public.content",
        @"public.text",
        @"public.source-code",
        @"public.image",
        @"public.audiovisual-content",
        @"com.adobe.pdf",
        @"com.apple.keynote.key",
        @"com.microsoft.word.doc",
        @"com.microsoft.excel.xls",
        @"com.microsoft.powerpoint.ppt"
    ];
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}


- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    
}


#if defined(__IPHONE_11_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls
{
    [self documentPicker:controller handlerWithUrl:urls.firstObject];
//    [controller dismissViewControllerAnimated:YES completion:nil];
}

#else

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [self documentPicker:controller handlerWithUrl:url];
//    [controller dismissViewControllerAnimated:YES completion:nil];
}

#endif

- (void)documentPicker:(UIDocumentPickerViewController *)controller handlerWithUrl:(NSURL *)url
{
    NSString *fileName = url.lastPathComponent;
    if ([ICouldManager iCouldEnable]) {
        [ICouldManager downloadFileWithDocumentUrl:url completion:^(NSData * _Nonnull data) {
            [self _uploadData:data filename:fileName];
        }];
    }
}



#pragma mark -viewfile


- (void)viewFile:(NSString *)filePath name:(NSString *)fileName
{
    ViewFileController *webVC = [[ViewFileController alloc] init];
    webVC.fileUrl = [NSURL fileURLWithPath:filePath];
    webVC.title = fileName;
//    webVC.modalPresentationStyle = UIModalPresentationPageSheet;
    GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:webVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}



- (void)updateUI:(NSNotification *)aNotif
{
    id obj = aNotif.object;
    if (obj && [obj isKindOfClass:[EMGroup class]]) {
        EMGroup *retGroup = (EMGroup *)obj;
        if ([retGroup.groupId isEqualToString:_group.groupId]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:retGroup.sharedFileList];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    self.page = 1;
    [self fetchBansWithPage:self.page isHeader:YES];
}

- (void)tableViewDidTriggerFooterRefresh
{
    self.page += 1;
    [self fetchBansWithPage:self.page isHeader:NO];
}

- (void)fetchBansWithPage:(NSInteger)aPage
                 isHeader:(BOOL)aIsHeader
{
    NSInteger pageSize = 10;
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    [[EMClient sharedClient].groupManager getGroupFileListWithId:self.group.groupId pageNumber:self.page pageSize:pageSize completion:^(NSArray *aList, EMError *aError) {
        [weakSelf hideHud];
        [weakSelf tableViewDidFinishTriggerHeader:aIsHeader reload:NO];
        if (!aError) {
            if (aIsHeader) {
                [weakSelf.dataArray removeAllObjects];
            }
            
            [weakSelf.dataArray addObjectsFromArray:aList];
            [weakSelf.tableView reloadData];
        } else {
            NSString *errorStr = [NSString stringWithFormat:NSLocalizedString(@"group.fetchSharedFileFail", @"fail to get share files: %@"), aError.errorDescription];
            [weakSelf showHint:errorStr];
        }
        
        if ([aList count] < pageSize) {
            self.showRefreshFooter = NO;
        } else {
            self.showRefreshFooter = YES;
        }
    }];
}

@end
