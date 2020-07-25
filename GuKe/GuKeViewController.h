//
//  GuKeViewController.h
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
//wang
#import <UserNotifications/UserNotifications.h>
#import "ConversationListController.h"

//end

@interface GuKeViewController : UITabBarController
//wang
@property (nonatomic, strong) ConversationListController *chatListVC;
- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;
//end
@end
