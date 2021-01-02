//
//  GuKeViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "GuKeViewController.h"
#import "MainViewController.h"
#import "ZJNInfoViewController.h"
#import "SuFangViewController.h"
#import "WoDeViewController.h"
#import "GuKeNavigationViewController.h"

//wang start
//#import "EaseConversationListViewController.h"
//#import "ConversationListController.h"
//wang
#import "ChatDemoHelper.h"
#import "ApplyViewController.h"
//end
#import "MessageController.h"

#import "WYYMainGroupViewController.h"   //我的群组
#import "WorkSpaceController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";
//end
@interface GuKeViewController (){
    EMConnectionState _connectionState;
    MainViewController *_mainVC;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (nonatomic, strong) ConversationListController *chatListVC;

@end

@implementation GuKeViewController

+(void)initialize{
    
    UITabBar *tabbar = [UITabBar appearance];
    tabbar.barTintColor = [UIColor whiteColor];
    
    UITabBarItem *tabbarItem = [UITabBarItem appearance];
    [tabbarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SetColor(0x06a27b)} forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    self.tabBar.translucent = NO ;
    //首页
    MainViewController *resource = [[MainViewController alloc]init];
    [self addChildViewController:resource andTitle:@"首页" andImageName:@"icon_home" andSelectedImage:@"icon_home_selected"];
    
    //消息
    
    _chatListVC = [[ConversationListController alloc] init];
    MessageController *msgController = [[MessageController alloc] init];
    msgController.chatListVC = _chatListVC;
    [self addChildViewController:msgController andTitle:@"消息" andImageName:@"icon_message" andSelectedImage:@"icon_message_selected"];
    
//    WYYMainGroupViewController *groupChatVC = [[WYYMainGroupViewController alloc] init];
    WorkSpaceController *groupInfoVC = [[WorkSpaceController alloc] init];
    [self addChildViewController:groupInfoVC andTitle:@"工作站" andImageName:@"icon_group" andSelectedImage:@"icon_group_selected"];
//    groupInfoVC.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    //资讯
    ZJNInfoViewController *class = [[ZJNInfoViewController alloc]init];
    [self addChildViewController:class andTitle:@"资讯" andImageName:@"icon_news" andSelectedImage:@"icon_news_selected"];
    
//    //随访
//    SuFangViewController *main = [[SuFangViewController alloc]init];
//    [self addChildViewController:main andTitle:@"随访" andImageName:@"icon3_1" andSelectedImage:@"icon3"];
    
    //我的
    WoDeViewController *wode = [[WoDeViewController alloc]init];
    [self addChildViewController:wode andTitle:@"我的" andImageName:@"icon_me" andSelectedImage:@"icon_me_selected"];

    //wang
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    self.selectedIndex = 0;
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
    [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;

    // Do any additional setup after loading the view from its nib.
}

//添加自控制器，设置标题，图片，和被选图片
-(void)addChildViewController:(UIViewController *)childViewController andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectedImage:(NSString *)selectedImageName{
    
    childViewController.tabBarItem.title = title;
    
    childViewController.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([childViewController isKindOfClass:[WoDeViewController class]]) {
        [self addChildViewController:childViewController];
    }else{
        GuKeNavigationViewController *nav = [[GuKeNavigationViewController alloc]initWithRootViewController:childViewController];
        
        [self addChildViewController:nav];
    }
    
}
//wang
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    //未读消息数
    NSInteger unreadCount = 0;
    //未读推送消息数
    NSInteger unreadPushMessageCount = 0;
    
    for (EMConversation *conversation in conversations) {
        if ([conversation.conversationId isEqualToString:@"admin"]) {
            unreadPushMessageCount += conversation.unreadMessagesCount;
        }else{
            unreadCount += conversation.unreadMessagesCount;
        }
        
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount+unreadPushMessageCount];
}
- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}
- (void)playSoundAndVibration{
    
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    options.displayStyle = EMPushDisplayStyleMessageSummary;
    
    if ((options.noDisturbStatus == 0)||(options.noDisturbStatus == 1)) {
        return;
    }
    
    
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    options.displayStyle = EMPushDisplayStyleMessageSummary;
    NSString *alertBody = nil;
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            // NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@",  NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@", NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        //  title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    // title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@",  messageStr];
        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
//end

- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_chatListVC) {
        if (unreadCount > 0) {
            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
            [_chatListVC.tableView reloadData];
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
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
