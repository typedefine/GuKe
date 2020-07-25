//
//  ZJNChangeFollowUpRequestModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/9.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Follow_UpRecordsRevisitModel.h"
@interface ZJNChangeFollowUpRequestModel : NSObject
/** 唯一标识 */
@property (nonatomic ,strong)NSString *sessionId;
/** 随访主键uid */
@property (nonatomic ,strong)NSString *checkId;
/** 随访时间 */
@property (nonatomic ,strong)NSString *visitTime;
/**创建时间 */
@property (nonatomic ,strong)NSString *createTime;
/** 体温 */
@property (nonatomic ,strong)NSString *temperature;
/** 脉搏 */
@property (nonatomic ,strong)NSString *pulse;
/** 呼吸 */
@property (nonatomic ,strong)NSString *breathe;
/** 血压 */
@property (nonatomic ,strong)NSString *pressure;
/** 专科检查 */
@property (nonatomic ,strong)NSString *checks;
/** harris评分 */
@property (nonatomic ,strong)NSString *harris;
/** hss评分 */
@property (nonatomic ,strong)NSString *hss;
/** sf评分 */
@property (nonatomic ,strong)NSString *sf;
/** 化验单 */
@property (nonatomic ,strong)NSString *hy;
/** 体位 */
@property (nonatomic ,strong)NSString *tw;
/** x光 */
@property (nonatomic ,strong)NSString *xg;
/** 步态视频 */
@property (nonatomic ,strong)NSString *video;
/** harris评分选项 */
@property (nonatomic ,strong)NSString *harrisuid;
/** hss评分选项 */
@property (nonatomic ,strong)NSString *hssuid;
/** sf评分选项 */
@property (nonatomic ,strong)NSString *sfuid;
/*评分数据*/
@property (nonatomic ,strong)NSMutableArray  *PingfenArray;

-(id)initWithModel:(Follow_UpRecordsRevisitModel *)model;
@end
