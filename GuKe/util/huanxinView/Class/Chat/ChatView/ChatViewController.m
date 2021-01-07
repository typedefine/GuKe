/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatViewController.h"

#import "ChatroomDetailViewController.h"
#import "UserProfileViewController.h"
#import "UserProfileManager.h"
#import "ContactListSelectViewController.h"
#import "ChatDemoHelper.h"
#import "EMChooseViewController.h"
#import "ContactSelectionViewController.h"
#import "EMGroupInfoViewController.h"

#import "WYYHuanZheXiangQingViewController.h"//患者详情
#import "WYYYishengDetailViewController.h"//医生详情
#import "WYYGroupDetailViewController.h"//群聊详情
#import "ICouldManager.h"
#import "ViewFileController.h"
#import "GuKeNavigationViewController.h"
#import "WorkStudioInfoController.h"
#import "WorkGroupInfoController.h"
#import "WorkSpaceInfoModel.h"
#import "GroupInfoModel.h"
#import "GroupOperationController.h"
#import "EMGroupSharedFilesViewController.h"
#import "GroupAddressbookController.h"
#import "GroupVideoListView.h"
#import "GroupVideoModel.h"
#import "OnScreenCommentsView.h"

@interface ChatViewController ()<UIAlertViewDelegate,EMClientDelegate, EMChooseViewDelegate, UIDocumentPickerDelegate, UIPopoverPresentationControllerDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    UIMenuItem *_recallItem;
    NSString *isDoctor;// 0医生 1患者
    NSString *doctorID;//医生id
    GroupInfoModel *_groupInfo;
}

@property (nonatomic, strong) UIButton *naviRightButton;
@property (nonatomic, strong) GroupVideoListView *videoListView;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic, strong) EMGroup *group;
@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property (nonatomic, strong) OnScreenCommentsView *floatView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHex:0xEDF1F4];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.backgroundColor = greenC;
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"状态栏-返回箭头"] forState:normal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, - 20, 0, 20);
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    if(![self.conversation.conversationId isEqualToString:@"gxs"]){
        self.naviRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        self.naviRightButton.backgroundColor = greenC;
        self.naviRightButton.accessibilityIdentifier = @"backs";
        
        //backButtons.imageEdgeInsets = UIEdgeInsetsMake(0, - 20, 0, 20);
        [self.naviRightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItems = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
        [self.navigationItem setRightBarButtonItem:backItems];
         if (![self.doctorId isEqualToString:@"gxs"] ) {
            
            if (self.conversation.type == EMConversationTypeChat) {
                [self.naviRightButton setImage:[UIImage imageNamed:@"man"] forState:normal];
                [self makeUseridData];
            }else{
                
                WorkSpaceInfoModel *m =  [[GuKeCache shareCache] objectForKey:kWorkStudioGroup_cache_key];
                if (m) {
                    [self addNaviToolBar];
                    [self addGroupVideoListView];
                    [self addOnScreenComments];
                    for (GroupInfoModel *studio in m.groups) {
                        studio.isJoined = YES;
                        studio.isOwner = YES;
                        if ([@(studio.groupId).stringValue isEqualToString:self.conversation.conversationId]) {
                            _groupInfo = studio;
                            break;
                        }else{
                            for (GroupInfoModel *group in studio.chatroom) {
                                group.isJoined = YES;
                                group.isOwner = YES;
                                if ([@(group.groupId).stringValue isEqualToString:self.conversation.conversationId]) {
                                    _groupInfo = group;
                                    break;
                                }
                            }
                        }
                    }
                }
                [self.naviRightButton setImage:[UIImage imageNamed:_groupInfo && _groupInfo.isOwner? @"MORE":@"group"] forState:normal];
                __weak typeof(self) weakSelf = self;
//                [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
                    EMError *error = nil;
                    EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:weakSelf.conversation.conversationId error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf hideHud];
                    });
                    if (!error) {
                        weakSelf.group = group;
                    }
                });
            }
        }
    
        
    }else{
        
        self.title =@"在线客服";
    }
    
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"chat_photoLibrary"] highlightedImage:[UIImage imageNamed:@"chat_photoLibrary"] title:@"相册" atIndex:0];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"chat_camera"] highlightedImage:[UIImage imageNamed:@"chat_camera"] title:@"相机" atIndex:1];
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"chat_file"] highlightedImage:[UIImage imageNamed:@"chat_file"] title:@"文件"];
    
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    //[self _setupBarButtonItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitChat) name:@"ExitChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
}

- (void)addNaviToolBar
{
    UIView *toolBar = [[UIView alloc] init];
    toolBar.tag = 888;
    toolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    DDCButton *contactBtn = [self createNaviToolBarButtonWithImagePath:@"group_contact" title:@" 通讯录"];
    [toolBar addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolBar).offset(IPHONE_X_SCALE(20));
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(65);
        make.centerY.equalTo(toolBar);
    }];
    [contactBtn addTarget:self action:@selector(viewContact) forControlEvents:UIControlEventTouchUpInside];
    
    DDCButton *fileBtn = [self createNaviToolBarButtonWithImagePath:@"group_share_file" title:@" 共享文件"];
    [toolBar addSubview:fileBtn];
    [fileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactBtn.mas_right).offset(IPHONE_X_SCALE(12));
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(toolBar);
    }];
    [fileBtn addTarget:self action:@selector(viewShareFiles) forControlEvents:UIControlEventTouchUpInside];
    
    DDCButton *videoBtn = [self createNaviToolBarButtonWithImagePath:@"group_video_normal" title:@" 视频"];
    videoBtn.tag = 999;
    [videoBtn setImage:[UIImage imageNamed:@"group_video_selected"] forState:UIControlStateSelected];
    [videoBtn setBackgroundColor:greenC forState:UIControlStateSelected];
    [videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [toolBar addSubview:videoBtn];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fileBtn.mas_right).offset(IPHONE_X_SCALE(12));
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(57);
        make.centerY.equalTo(toolBar);
    }];
    [videoBtn addTarget:self action:@selector(viewVideos:) forControlEvents:UIControlEventTouchUpInside];
}

- (DDCButton *)createNaviToolBarButtonWithImagePath:(NSString *)imagePath title:(NSString *)title
{
    DDCButton *btn = [DDCButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [btn setTitleColor:[UIColor colorWithHex:0x3C3E3D] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 12.5;
    [btn setLayerBorderColor:[UIColor colorWithHex:0x3C3E3D] forState:UIControlStateNormal];
//    btn.layer.borderColor = [UIColor colorWithHex:0x3C3E3D].CGColor;
//    btn.layer.borderWidth = 1;
    return btn;
}

- (void)viewContact
{
    GroupAddressbookController *vc = [[GroupAddressbookController alloc] init];
    vc.groupInfo = _groupInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewShareFiles
{
    if(self.group){
        EMGroupSharedFilesViewController *vc = [[EMGroupSharedFilesViewController alloc] initWithGroup:self.group];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)viewVideos:(DDCButton *)btn
{
    btn.selected = !btn.selected;
    self.videoListView.hidden = !btn.selected;
}

- (void)getGroupVideosWithConfig:(void (^)(id data))videoListViewConfig
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,urlpath_work_group_video];
    NSDictionary *para = @{
        @"sessionId":sessionIding,
        @"groupId":self.conversation.conversationId,
    };
   
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        NSLog(@"工作室悬浮视频列表-->%@",data);
        [self hideHud];
        if ([data[@"retcode"] isEqualToString:@"0000"]) {
            videoListViewConfig(data[@"data"]);
        }
    } failure:^(NSError *error) {
        NSLog(@"工作室悬浮视频列表-->%@",error);
        [self hideHud];
        [self showHint:@"创建工作室失败" inView:self.view];
    }];
}

- (void)getGroupVideos
{
    __weak typeof(self) weakSelf = self;
    void (^ configVideoListView)(id data) = ^(id data){
        [self.videoListView configWithData:data clicked:^(GroupVideoModel *model) {
            [weakSelf playVideoWithUrl:[NSURL URLWithString:model.content]];
        } collapse:^{
            weakSelf.videoListView.hidden = YES;
            UIView *toolsBar = [self.view viewWithTag:888];
            DDCButton *videoBtn = [toolsBar viewWithTag:999];
            videoBtn.selected = NO;
        }];
    };
    
    [self getGroupVideosWithConfig:configVideoListView];
}

- (void)addGroupVideoListView
{
    [self.view addSubview:self.videoListView];
    [self.videoListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(IPHONE_X_SCALE(165));
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(45);
    }];
    [self getGroupVideos];
}


- (void)addOnScreenComments
{
    [self.view addSubview:self.floatView];
    [self.floatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.height.mas_equalTo(45);
    }];
    [self.floatView configWithData:nil];
}

#pragma mark 根据user_id 判断医生还是患者
- (void)makeUseridData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinDistinguish];
    NSArray *keysArray = @[@"userId"];
    NSArray *valueArray = @[self.conversation.conversationId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            isDoctor = [NSString stringWithFormat:@"%@",data[@"data"][@"isDoctor"]];
            doctorID = [NSString stringWithFormat:@"%@",data[@"data"][@"doctorId"]];
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)rightAction{
    if (self.conversation.type == EMConversationTypeChat){
        if ([isDoctor isEqualToString:@"1"]) {
            WYYHuanZheXiangQingViewController *huanzhe = [[WYYHuanZheXiangQingViewController alloc]init];
            huanzhe.hidesBottomBarWhenPushed = YES;
            huanzhe.userIDStr = self.conversation.conversationId;
            [self.navigationController pushViewController:huanzhe animated:NO];
        }else{
            WYYYishengDetailViewController *detail = [[WYYYishengDetailViewController alloc]init];
            detail.doctorId = doctorID;
            detail.deleteStr = @"1";
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:NO];
        }
        
    }else{
        if (_groupInfo) {
            if (_groupInfo.isOwner) {
                GroupOperationController *vc = [[GroupOperationController alloc] init];
                vc.targetController = self;
                vc.groupInfo = _groupInfo;
                vc.preferredContentSize = CGSizeMake(IPHONE_X_SCALE(180), _groupInfo.groupType==1?IPHONE_X_SCALE(205):IPHONE_X_SCALE(100));
                vc.modalPresentationStyle = UIModalPresentationPopover;

                UIPopoverPresentationController *popver = vc.popoverPresentationController;
                popver.delegate = self;
                    //弹出时参照视图的大小，与弹框的位置有关
                popver.sourceRect = self.naviRightButton.bounds;
                //弹出时所参照的视图，与弹框的位置有关
                popver.sourceView = self.naviRightButton;
                //弹框的箭头方向
                popver.permittedArrowDirections = UIPopoverArrowDirectionUp;

                [self presentViewController:vc animated:YES completion:nil];
                
            }else{
                if (_groupInfo.groupType == 1) {
                    WorkStudioInfoController *vc = [[WorkStudioInfoController alloc] init];
                    vc.isFromChat = YES;
                    vc.groupInfo = _groupInfo;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:NO];
                }else if(_groupInfo.groupType > 1){
                    WorkGroupInfoController *vc = [[WorkGroupInfoController alloc] init];
                    vc.groupInfo = _groupInfo;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:NO];
                }
            }
        }else{
            WYYGroupDetailViewController *group = [[WYYGroupDetailViewController alloc]init];
            group.groupID = self.conversation.conversationId;
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:NO];
        }
    }
    
}


// -------UIPopoverPresentationControllerDelegate
// 默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
// 设置点击蒙版是否消失，默认为YES
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    return YES;
}
// 弹出视图消失后调用的方法
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    
}



- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom) {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    
    [[EMClient sharedClient] removeDelegate:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"subject"] length])
        {
            self.title = [ext objectForKey:@"subject"];
        }
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
}

- (void)tableViewDidTriggerHeaderRefresh {
    if ([[ChatDemoHelper shareHelper] isFetchHistoryChange]) {
        NSString *startMessageId = nil;
        if ([self.messsagesSource count] > 0) {
            startMessageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
        }
        NSLog(@"startMessageID ------- %@",startMessageId);
        [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.conversation.conversationId
                                                              conversationType:self.conversation.type
                                                                startMessageId:startMessageId
                                                                      pageSize:10
                                                                    completion:^(EMCursorResult *aResult, EMError *aError)
        {
            [super tableViewDidTriggerHeaderRefresh];
        }];
       
    } else {
        [super tableViewDidTriggerHeaderRefresh];
    }
}


#pragma mark - setup subviews

- (OnScreenCommentsView *)floatView
{
    if (!_floatView) {
        _floatView = [[OnScreenCommentsView alloc] init];
    }
    return _floatView;
}

- (GroupVideoListView *)videoListView
{
    if (!_videoListView) {
        _videoListView = [[GroupVideoListView alloc] init];
        _videoListView.hidden = YES;
    }
    return _videoListView;
}

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //单聊
    if (self.conversation.type == EMConversationTypeChat) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        clearButton.accessibilityIdentifier = @"clear_message";
        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
    else{//群聊
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        detailButton.accessibilityIdentifier = @"detail";
        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
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
            [self uploadFileWithName:fileName fileData:data];
        }];
    }
}


- (void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)data
{
    NSDictionary *dic = @{@"userPic":[NSString stringWithFormat:@"%@%@",imgPath,ChatImgUrl],@"userName":[NSString stringWithFormat:@"%@",ChatUserName]};
    EMMessage *message = [EaseSDKHelper getFileMessageWithData:data fileName:fileName to:self.conversation.conversationId messageType:[self messageTypeFromConversationType] messageExt:dic];
    [self sendFileMessageWith:message];
}



#pragma mark - EaseMessageViewControllerDelegate

//- (BOOL)messageViewController:(EaseMessageViewController *)viewController didSelectMessageModel:(id<IMessageModel>)messageModel
//{
//    return YES;
//}

- (void)messageViewController:(EaseMessageViewController *)viewController didSelectMoreView:(EaseChatBarMoreView *)moreView AtIndex:(NSInteger)index
{
    if (index == 2) {
        //file
        [self selectUploadFileFromICouldDrive];
    }
}


- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *ext = messageModel.message.ext;
    if ([ext objectForKey:@"em_recall"]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *recallCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (recallCell == nil) {
            recallCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            recallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        EMTextMessageBody *body = (EMTextMessageBody*)messageModel.message.body;
        recallCell.title = body.text;
        return recallCell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    NSDictionary *ext = messageModel.message.ext;
    if ([ext objectForKey:@"em_recall"]) {
        return self.timeCellHeight;
    }
    return 0;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EaseMessageCell class]]) {
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
//    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:messageModel.message.from];
//    [self.navigationController pushViewController:userprofile animated:YES];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak ChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:chatGroup.groupId error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong ChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
                            selectController.mulChoice = NO;
                            selectController.delegate = self;
                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
            selectController.mulChoice = NO;
            selectController.delegate = self;
            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
    if (profileEntity) {
        model.avatarURLPath = profileEntity.imageUrl;
        model.nickname = profileEntity.nickname;
    }
    
    if (model.isSender) {
        
        model.avatarURLPath = [NSString stringWithFormat:@"%@%@",imgPath,ChatImgUrl];
        model.nickname = ChatUserName;
    }else{
        //对方头像
        model.avatarURLPath = [NSString stringWithFormat:@"%@",message.ext[@"userPic"]];
        model.nickname = message.ext[@"userName"];
    }
    //model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidRecall:(NSArray *)aMessages
{
    for (EMMessage *msg in aMessages) {
        if (![self.conversation.conversationId isEqualToString:msg.conversationId]){
            continue;
        }
        
        NSString *text;
        if ([msg.from isEqualToString:[EMClient sharedClient].currentUsername]) {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recall", @"You recall a message")];
        } else {
            text = [NSString stringWithFormat:NSLocalizedString(@"message.recallByOthers", @"%@ recall a message"),msg.from];
        }
        
        [self _recallWithMessage:msg text:text isSave:NO];
    }
}

#pragma mark - action

- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[ChatDemoHelper shareHelper] setChatVC:nil];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        EMGroupInfoViewController *infoController = [[EMGroupInfoViewController alloc] initWithGroupId:self.conversation.conversationId];
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else if (self.conversation.type == EMConversationTypeChatRoom)
    {
        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

- (void)recallMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        __weak typeof(self) weakSelf = self;
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        [[EMClient sharedClient].chatManager recallMessage:model.message
                                                completion:^(EMMessage *aMessage, EMError *aError) {
                                                    if (!aError) {
                                                        [weakSelf _recallWithMessage:aMessage text:NSLocalizedString(@"message.recall", @"You recall a message") isSave:YES];
                                                    } else {
                                                        [weakSelf showHint:[NSString stringWithFormat:NSLocalizedString(@"recallFailed", @"Recall failed:%@"), aError.errorDescription]];
                                                    }
                                                    weakSelf.menuIndexPath = nil;
                                                }];
    }
}

- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.messageModel = model;
        [listViewController tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitChat
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (_recallItem == nil) {
        _recallItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"recall", @"Recall") action:@selector(recallMenuAction:)];
    }
    
    NSMutableArray *items = [NSMutableArray array];
    
    if (messageType == EMMessageBodyTypeText) {
        [items addObject:_copyMenuItem];
        [items addObject:_transpondMenuItem];
        [items addObject:_deleteMenuItem];
    } else if (messageType == EMMessageBodyTypeImage || messageType == EMMessageBodyTypeVideo) {
        [items addObject:_transpondMenuItem];
        [items addObject:_deleteMenuItem];
    } else {
        [items addObject:_deleteMenuItem];
    }
    
    id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
    if (model.isSender) {
        [items addObject:_recallItem];
    }
    
    [self.menuController setMenuItems:items];
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)_recallWithMessage:(EMMessage *)msg text:(NSString *)text isSave:(BOOL)isSave
{
    EMMessage *message = [EaseSDKHelper getTextMessage:text to:msg.conversationId messageType:msg.chatType messageExt:@{@"em_recall":@(YES)}];
    message.isRead = YES;
    [message setTimestamp:msg.timestamp];
    [message setLocalTime:msg.localTime];
    id<IMessageModel> newModel = [[EaseMessageModel alloc] initWithMessage:message];
    __block NSUInteger index = NSNotFound;
    [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
        if ([model conformsToProtocol:@protocol(IMessageModel)]) {
            if ([msg.messageId isEqualToString:model.message.messageId])
            {
                index = idx;
                *stop = YES;
            }
        }
    }];
    if (index != NSNotFound)
    {
        __block NSUInteger sourceIndex = NSNotFound;
        [self.messsagesSource enumerateObjectsUsingBlock:^(EMMessage *message, NSUInteger idx, BOOL *stop){
            if ([message isKindOfClass:[EMMessage class]]) {
                if ([msg.messageId isEqualToString:message.messageId])
                {
                    sourceIndex = idx;
                    *stop = YES;
                }
            }
        }];
        if (sourceIndex != NSNotFound) {
            [self.messsagesSource replaceObjectAtIndex:sourceIndex withObject:newModel.message];
        }
        [self.dataArray replaceObjectAtIndex:index withObject:newModel];
        [self.tableView reloadData];
    }
    
    if (isSave) {
        [self.conversation insertMessage:message error:nil];
    }
}


#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    if ([selectedSources count]) {
        EaseAtTarget *target = [[EaseAtTarget alloc] init];
        target.userId = selectedSources.firstObject;
        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:target.userId];
        if (profileEntity) {
            target.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        }
        if (_selectedCallback) {
            _selectedCallback(target);
        }
    }
    else {
        if (_selectedCallback) {
            _selectedCallback(nil);
        }
    }
    return YES;
}

- (void)viewControllerDidSelectBack:(EMChooseViewController *)viewController
{
    if (_selectedCallback) {
        _selectedCallback(nil);
    }
}

@end
