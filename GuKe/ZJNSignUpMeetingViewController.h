//
//  ZJNSignUpMeetingViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNSignUpMeetingViewController : UIViewController
@property (nonatomic ,strong)NSString *status;
@property (nonatomic ,strong)NSString *huiyiID;
@property (nonatomic ,strong)NSString *shareImagePath;
@property (nonatomic ,strong)NSString *sharetitle;
@property (nonatomic ,strong)NSString *content;
@property (nonatomic ,strong)NSString *meetingModel;  //0 热门会议 1 专项会议
@property (strong ,nonatomic) NSString * urlStr;
@property (copy ,nonatomic) NSString * meetShow; // 1 yong 九宫格显示  0 用 瀑布流显示
@property (copy ,nonatomic) NSString * switchState;

@property (nonatomic ,strong)NSString *live;//0 无  1 直播中  2回放
@property (nonatomic ,strong)NSString *specialAllow;//0 不显示报名  1 显示报名
@property (nonatomic ,copy)void(^refershList)(NSString *type);
@property (nonatomic ,strong)NSString *payState;// 回放和直播的时候能不能观看，0代表不能看，1代表可以
@end
