//
//  AppDelegate.h
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *callid;
//+(AppDelegate*)shareInstance;
-(void)toast:(NSString*)message;

@end

