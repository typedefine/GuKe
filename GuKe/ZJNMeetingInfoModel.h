//
//  ZJNMeetingInfoModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNMeetingInfoModel : NSObject
@property (nonatomic ,strong)NSString *content;//废弃
@property (nonatomic ,strong)NSString *newcontent;
@property (nonatomic ,strong)NSString *count;
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *meetingName;
@property (nonatomic ,strong)NSString *site;
@property (nonatomic ,strong)NSString *stats;
@property (nonatomic ,strong)NSString *time;
@property (nonatomic ,strong)NSArray  *doctor;
@property (nonatomic ,strong)NSArray  *liveList;


@end
