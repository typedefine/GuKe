//
//  moduleDate.h
//  GuKe
//
//  Created by MYMAc on 2019/2/26.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 统计应用使用时长和模块使用时长
 */
@interface moduleDate : NSObject
@property (strong ,nonatomic) NSDate * OpenAPPDate;// 开始时间
@property (assign ,nonatomic) NSInteger TrainingLength;// 专项培训时长
@property (assign ,nonatomic) NSInteger MeetingLength;// 热门会议时长
@property (assign ,nonatomic) NSInteger DouctFriendsLength;// 医生好友
//@property (strong ,nonatomic) NSString * ShipinLength;// 手术量
//@property (strong ,nonatomic) NSString * ShipinLength;// 病例量
//@property (strong ,nonatomic) NSString * ShipinLength;// 随访量
@property (assign ,nonatomic) NSInteger ShipinLength;// 视频时长
@property (assign ,nonatomic) NSInteger MessageLength;// 消息时长
@property (assign ,nonatomic) NSInteger IformationLength;// 资讯时长
@property (assign ,nonatomic) NSInteger MymeetingLength;// 我组织的会议时长

+(instancetype)ShareModuleDate;
-(void)CommitData;// 提交数据 应用放到后台的时候 或者退出的登录的时候  上传成功清除数据
-(void)removeDate;// 删除数据；


@end

NS_ASSUME_NONNULL_END
