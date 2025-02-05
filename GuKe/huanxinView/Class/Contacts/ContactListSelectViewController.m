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

#import "ContactListSelectViewController.h"

#import "ChatViewController.h"
#import "UserProfileManager.h"
//#import "RedPacketChatViewController.h"

@interface ContactListSelectViewController () <EMUserListViewControllerDelegate,EMUserListViewControllerDataSource>

@end

@implementation ContactListSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark - EMUserListViewControllerDelegate
- (void)userListViewController:(EaseUsersListViewController *)userListViewController
            didSelectUserModel:(id<IUserModel>)userModel
{
    if (!self.messageModel) {
        return;
    }
    
    if (self.messageModel.bodyType == EMMessageBodyTypeText) {
        [self forwardTextMessageToUser:userModel];
    } else if (self.messageModel.bodyType == EMMessageBodyTypeImage) {
        [self forwardImageMessageToUser:userModel];
    } else if (self.messageModel.bodyType == EMMessageBodyTypeVideo) {
        [self forwardVideoMessageToUser:userModel];
    }
}


- (void)forwardTextMessageToUser:(id<IUserModel>)userModel {
    EMMessage *message = [EaseSDKHelper getTextMessage:self.messageModel.text to:userModel.buddy messageType:EMChatTypeChat messageExt:self.messageModel.message.ext];
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            UIViewController *chatController = nil;
#ifdef REDPACKET_AVALABLE
            chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
#else
            chatController = [[ChatViewController alloc]
                              initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
#endif
            chatController.title = userModel.nickname.length != 0 ? [userModel.nickname copy] : [userModel.buddy copy];
            if ([array count] >= 3) {
                [array removeLastObject];
                [array removeLastObject];
            }
            [array addObject:chatController];
            [weakself.navigationController setViewControllers:array animated:YES];
        } else {
            [weakself showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
        }
    }];
}

- (void)forwardImageMessageToUser:(id<IUserModel>)userModel {
    [self showHudInView:self.view hint:NSLocalizedString(@"transponding", @"transponding...")];
    
    __weak typeof(self) weakSelf = self;
    NSString *thumbnailLocalPath = [(EMImageMessageBody *)self.messageModel.message.body thumbnailLocalPath];
    NSString *localPath = [(EMImageMessageBody *)self.messageModel.message.body localPath];
    UIImage *image = [UIImage imageWithContentsOfFile:(thumbnailLocalPath && thumbnailLocalPath.length > 0) ? thumbnailLocalPath:localPath];
    
    void (^block)() = ^(EMMessage *message){
        EMImageMessageBody *imgBody = (EMImageMessageBody *)message.body;
        NSString *from = [[EMClient sharedClient] currentUsername];
        EMImageMessageBody *newBody = [[EMImageMessageBody alloc] initWithData:nil thumbnailData:[NSData dataWithContentsOfFile:imgBody.thumbnailLocalPath]];
        newBody.thumbnailLocalPath = imgBody.thumbnailLocalPath;
        newBody.thumbnailRemotePath = imgBody.thumbnailRemotePath;
        newBody.remotePath = imgBody.remotePath;
        EMMessage *newMsg = [[EMMessage alloc] initWithConversationID:userModel.buddy from:from to:userModel.buddy body:newBody ext:message.ext];
        newMsg.chatType = EMChatTypeChat;
        
        [[EMClient sharedClient].chatManager sendMessage:newMsg progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            [(EMImageMessageBody *)message.body setLocalPath:imgBody.localPath];
            [[EMClient sharedClient].chatManager updateMessage:message completion:nil];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[weakSelf.navigationController viewControllers]];
            
#ifdef REDPACKET_AVALABLE
            RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
#else
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
#endif
            chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
            if ([array count] >= 3) {
                [array removeLastObject];
                [array removeLastObject];
            }
            [array addObject:chatController];
            [weakSelf.navigationController setViewControllers:array animated:YES];
        }];
    };
    
    if (!image) {
        [[EMClient sharedClient].chatManager downloadMessageThumbnail:self.messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            block(message);
        }];
    } else {
        block(self.messageModel.message);
    }
    
}

- (void)forwardVideoMessageToUser:(id<IUserModel>)userModel {
    [self showHudInView:self.view hint:NSLocalizedString(@"transponding", @"transponding...")];
    
    __weak typeof(self) weakSelf = self;
    NSString *localPath = [(EMVideoMessageBody *)self.messageModel.message.body localPath];
    EMDownloadStatus downloadStatus = [(EMVideoMessageBody *)self.messageModel.message.body downloadStatus];
    
    void (^block)() = ^(EMMessage *message){
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.body;
        NSString *from = [[EMClient sharedClient] currentUsername];
        EMVideoMessageBody *newBody = [[EMVideoMessageBody alloc] initWithLocalPath:[videoBody localPath]
                                                                        displayName:@"video.mp4"];
        newBody.thumbnailLocalPath = videoBody.thumbnailLocalPath;
        EMMessage *newMsg = [[EMMessage alloc] initWithConversationID:userModel.buddy from:from to:userModel.buddy body:newBody ext:message.ext];
        newMsg.chatType = EMChatTypeChat;
        
        [[EMClient sharedClient].chatManager sendMessage:newMsg progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            [(EMImageMessageBody *)message.body setLocalPath:videoBody.localPath];
            [[EMClient sharedClient].chatManager updateMessage:message completion:nil];
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[weakSelf.navigationController viewControllers]];
            
#ifdef REDPACKET_AVALABLE
            RedPacketChatViewController *chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
#else
            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:userModel.buddy conversationType:EMConversationTypeChat];
#endif
            chatController.title = userModel.nickname.length != 0 ? userModel.nickname : userModel.buddy;
            if ([array count] >= 3) {
                [array removeLastObject];
                [array removeLastObject];
            }
            [array addObject:chatController];
            [weakSelf.navigationController setViewControllers:array animated:YES];
        }];
    };
    
    if (!localPath || downloadStatus != EMDownloadStatusSuccessed) {
        [[EMClient sharedClient].chatManager downloadMessageAttachment:self.messageModel.message progress:nil completion:^(EMMessage *message, EMError *error) {
            if (error) {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"transpondFail", @"transpond Fail")];
                [weakSelf performSelector:@selector(backAction) withObject:nil afterDelay:1];
                return ;
            }
            
            block(message);
        }];
    } else {
        block(self.messageModel.message);
    }
    
}

#pragma mark - EMUserListViewControllerDataSource
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
    if (profileEntity) {
        model.nickname= profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        model.avatarURLPath = profileEntity.imageUrl;
    }
    return model;
}

- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                   userModelForIndexPath:(NSIndexPath *)indexPath
{
    id<IUserModel> model = nil;
    model = [self.dataArray objectAtIndex:indexPath.row];
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.buddy];
    if (profileEntity) {
        model.nickname= profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        model.avatarURLPath = profileEntity.imageUrl;
    }
    return model;
}

#pragma mark - action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
