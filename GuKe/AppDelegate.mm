//
//  AppDelegate.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GuKeViewController.h"
#import "IQKeyboardManager.h"
#import "MainViewController.h"
#import "WoDeViewController.h"
#import "SuFangViewController.h"
#import "ZJNFalseViewController.h"
#import "UMMobClick/MobClick.h"
#import "WXApi.h"
//wang start
#import "ChatDemoHelper.h"
#import "InvitationManager.h"
#import "ApplyViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WYYFMDBManager.h"
#import "WYYYIshengFriend.h"
#import "moduleDate.h"

#import "ZYNetworkAccessibity.h"
//end
@interface AppDelegate ()<EMChatManagerDelegate,EMContactManagerDelegate,EMClientDelegate,WXApiDelegate>{
    WYYFMDBManager *_db;
    NSArray *_dataSource;
    
    BOOL CommitData; // 是否提交 YES提交 NO不提交 用于判断未登录时，打开APP不用提交
}
@property (nonatomic, strong) LoginViewController *loginView;
@property (nonatomic, strong) ZJNFalseViewController *falseRootViewC;
@property (nonatomic, strong) GuKeViewController *mainView;
@property (nonatomic, strong) NSDateFormatter *dataformater;
@end

@implementation AppDelegate

////自定义
+(AppDelegate*)shareInstance {
    return [UIApplication sharedApplication].delegate;
}
-(void)toast:(NSString*)message {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ZYNetworkAccessibity setAlertEnable:YES];
    
    [ZYNetworkAccessibity setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        NSLog(@"setStateDidUpdateNotifier > %zd", state);
    }];
    
    [ZYNetworkAccessibity start];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    CommitData = NO ;
//     [moduleDate ShareModuleDate];
    
    // 每次进来更新好友信息
    [self makeFriendsData];
    //这里设置UITableView 是因为在项目中使用的MJRefresh在iOS11系统上 上拉加载会出现问题  一直循环执行
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //友盟统计
    UMConfigInstance.appKey = @"59f92796aed1794764000059";
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
//    EMOptions *options = [EMOptions optionsWithAppkey:@"1111171031115367#mrboneproject"];
//    options.apnsCertName = @"aps_development";
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59f92796aed1794764000059"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    //设置键盘
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:14]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

//    _falseRootViewC = [[ZJNFalseViewController alloc]init];
//    _loginView = [[LoginViewController alloc]init];
//    NSString *pwdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"passWord"];
//
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    if (pwdStr) {
//        self.window.rootViewController = _falseRootViewC;
//        [self didDengluButton];
//    }else{
//        self.window.rootViewController = _loginView;
//    }
    /*
    //start
    EMOptions *option = [EMOptions optionsWithAppkey:@"1126180111115795#mrbone"];
//    NSString *apnsCertName = @"guxianshengdevelopment";
    NSString *apnsCertName = @"develop";
//
    option.apnsCertName = apnsCertName;
    [[EMClient sharedClient]initializeSDKWithOptions:option];
    */
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
//#if !TARGET_IPHONE_SIMULATOR
        if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [application registerForRemoteNotifications];
        }else{
            UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
            UIRemoteNotificationTypeSound |
            UIRemoteNotificationTypeAlert;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        }
/*
    [[EMClient sharedClient]addDelegate:self delegateQueue:nil];
    */
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:key_login_notification
                                               object:nil];
    /*
    [[EaseSDKHelper shareHelper]hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"1126180111115795#mrbone" apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    [ChatDemoHelper shareHelper];
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    //end
    */
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"logined"];
    [[NSNotificationCenter defaultCenter] postNotificationName:key_login_notification object:@(num && num.intValue == 1)];

    
#warning 登陆待处理
    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return YES;
    }
    return YES;
}


- (void)loginStateChange:(NSNotification *)notification
{
    
    BOOL loginSuccess = [notification.object boolValue];
    if(loginSuccess){
        GuKeViewController *view = [GuKeViewController new];
        /*
        [ChatDemoHelper shareHelper].mainVC = view;
        
        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
        [[ChatDemoHelper shareHelper] asyncPushOptions];
        */
        _dataSource = [[ApplyViewController shareController] dataSource];
        //[self acceptGroupInvitation];
        self.window.rootViewController = view;
        [self.window makeKeyAndVisible];
//    登录成功 开始计时
        [moduleDate ShareModuleDate];

    }else{
        if (CommitData) {
            //    退出登录 上传数据
            [[moduleDate ShareModuleDate] CommitData];
       }
        CommitData  = YES ;
        //登录失败加载登录页面控制器
        LoginViewController *view = [LoginViewController new];
        [ChatDemoHelper shareHelper].mainVC = nil;
        self.window.rootViewController = view;
        
        
        /*
         #pragma    mark   判断是不是 第一次登陆
         BOOL  isFirst =  YES;
         isFirst =( BOOL )[[NSUserDefaults standardUserDefaults]  boolForKey:@"MMIsFirst"];
         NSLog(@" ++  %d",isFirst);
         
         if (!isFirst) {
         ZJNTabBarViewController * gvc =[[ZJNTabBarViewController alloc]init];
         self.window.rootViewController  = gvc;
         }else{
         //登录失败加载登录页面控制器
         ZJNHLoginViewController *view = [ZJNHLoginViewController new];
         [ChatDemoHelper shareHelper].mainVC = nil;
         self.window.rootViewController = view;
         
         
         }
         */
        [self.window makeKeyAndVisible];
        
    }
}
//登录
- (void)didDengluButton{
   
    NSString *pwdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"passWord"];
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,logining];
    NSArray *keysArray = @[@"userName",@"pwd"];
    NSArray *valueArray = @[phoneStr,pwdStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:data[@"data"][@"sessionId"] forKey:@"sessionIdUser"];
            
            [defaults setObject:phoneStr forKey:@"userPhone"];
            
            [defaults setObject:pwdStr forKey:@"passWord"];
            
            [defaults setObject:data[@"data"][@"userId"] forKey:@"UserId"];
            
            [defaults setObject:data[@"data"][@"state"] forKey:@"STATE"];//保存认证状态
            [defaults synchronize];
            GuKeViewController *viewC = [[GuKeViewController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController=viewC;
        }else{
            [UIApplication sharedApplication].keyWindow.rootViewController=_loginView;
        }
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].keyWindow.rootViewController=_loginView;
        NSLog(@"%@",error);
    }];
    
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx64369d165e1a329a" appSecret:@"3df86849bd603825cae54192543a190a" redirectURL:nil];
    [WXApi registerApp:@"wx64369d165e1a329a"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106508046"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
       
        if ([url.host caseInsensitiveCompare:@"safepay"] == NSOrderedSame) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AIRSUCCESS" object:resultDic];
                
            }];
        }else if ([url.host caseInsensitiveCompare:@"pay"] == NSOrderedSame){
            return [WXApi handleOpenURL:url delegate:self];
            
        }
        
    }
    return result;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host caseInsensitiveCompare:@"safepay"] == NSOrderedSame) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AIRSUCCESS" object:resultDic];
            NSLog(@"result = %@",resultDic);
        }];
    }else if ([url.host caseInsensitiveCompare:@"pay"] == NSOrderedSame){
        return [WXApi handleOpenURL:url delegate:self];
    }    return YES;
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAYSUCCESS" object:resp];
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error{
    NSLog(@"error%@",error);
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient]applicationDidEnterBackground:application];
    [[moduleDate ShareModuleDate] CommitData];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


#pragma mark  好友医生列表
- (void)makeFriendsData{
    if(!sessionIding){
        return ;
        
    }
    
    
    [self makeData];// 客服信息
    [self makeGroupData];// 群组信息

    _db = [WYYFMDBManager shareWYYManager];

    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinfreindlist];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
     [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
         
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
       
         if ([retcode isEqualToString:@"0000"]) {
            NSArray *arays = [NSArray arrayWithArray:data[@"data"]];
            if (arays.count == 0) {
                
            }else{
                for (NSDictionary *dic in arays) {
                    WYYYIshengFriend *model = [WYYYIshengFriend yy_modelWithJSON:dic];
                    NSLog(@" %@ -- dic= %@",model.name,dic);
                   
                    [_db addFriendListModel:model];
                    
                 }
              }
        
         }

     } failure:^(NSError *error) {
         
      }];
}


#pragma mark  获取在线客服信息
- (void)makeData{
 
   
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfriendlookdoctor];
    NSArray *keysArray = @[@"sessionId",@"userid"];
    NSArray *valueArray = @[sessionIding,@"gxs"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
     [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
         NSLog(@"医生详情%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            
            WYYYIshengFriend *model = [[WYYYIshengFriend alloc]init];
            model.name  = data[@"data"][@"titleName"];
            model.userId  = data[@"data"][@"uid"];
            model.portrait  = data[@"data"][@"portrait"];
            [_db addFriendListModel:model];
            

        }
    } failure:^(NSError *error) {
         NSLog(@"医生详情%@",error);
    }];
}


#pragma mark  我的群列表
- (void)makeGroupData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,chatgroupsmygroup];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
         NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
          NSMutableArray *  groupArr = [NSMutableArray arrayWithArray:data[@"data"]];
            
            for (NSDictionary *dicat in groupArr) {
                WYYYIshengFriend *model = [WYYYIshengFriend yy_modelWithJSON:dicat];
                [_db addFriendListModel:model];
            }
            
         }
     } failure:^(NSError *error) {
     }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
     [moduleDate ShareModuleDate];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
