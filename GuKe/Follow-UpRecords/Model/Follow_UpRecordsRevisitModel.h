//
//  Follow-UpRecordsRevisitModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Follow_UpRecordsRevisitModel : NSObject
@property (nonatomic ,strong)NSString *breathe;
@property (nonatomic ,strong)NSString *checks;
@property (nonatomic ,strong)NSString *createTime;
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *harris;
@property (nonatomic ,strong)NSString *harrisuid;
@property (nonatomic ,strong)NSString *hospnumId;
@property (nonatomic ,strong)NSString *hss;
@property (nonatomic ,strong)NSString *hssuid;
@property (nonatomic ,strong)NSString *pressure;
@property (nonatomic ,strong)NSString *pulse;
@property (nonatomic ,strong)NSString *sf;
@property (nonatomic ,strong)NSString *sfuid;
@property (nonatomic ,strong)NSString *state;
@property (nonatomic ,strong)NSString *temperature;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *visitTime;
@property (nonatomic ,strong)NSString *selectedButton;//1 化验单 2 x光  3 体位照  4步态小视频
@property (nonatomic ,strong)NSArray  *hyimages;
@property (nonatomic ,strong)NSArray  *twimages;
@property (nonatomic ,strong)NSArray  *videos;
@property (nonatomic ,strong)NSArray  *ximages;
@property (nonatomic ,strong)NSMutableArray  *PingfenArray;
@end
