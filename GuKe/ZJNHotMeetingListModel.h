//
//  ZJNHotMeetingListModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/1/18.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNHotMeetingListModel : NSObject
@property (nonatomic ,strong)NSString *beginTime;
@property (nonatomic ,strong)NSString *content;
@property (nonatomic ,strong)NSString *count;
@property (nonatomic ,strong)NSString *createUser;
@property (nonatomic ,strong)NSString *image;
@property (nonatomic ,strong)NSString *live;
@property (nonatomic ,strong)NSString *meetingModel;  //0 热门会议 1 专项会议
@property (nonatomic ,strong)NSString *meetShow;// 0 瀑布 1 九宫格
@property (nonatomic ,strong)NSString *specialAllow;// 是否显示报名按钮 1 显示 0 不显示
@property (nonatomic ,strong)NSString *switchState;// 是否允许切换模式 1 允许 0 不允许
@property (nonatomic ,strong)NSString *payState;// 回放和直播的时候能不能观看，0代表不能看，1代表可以


@property (nonatomic ,strong)NSString *meetingName;
@property (nonatomic ,strong)NSString *shou;
@property (nonatomic ,strong)NSString *site;
@property (nonatomic ,strong)NSString *stats;
@property (nonatomic ,strong)NSString *uid;
@end
