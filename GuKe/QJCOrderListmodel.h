//
//  QJCOrderListmodel.h
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJCOrderListmodel : NSObject
/**
 meetPrice = 0;
 meetSite = "fs\U6c34\U7535\U8d39\U7b2c\U4e09\U4e2a";
 meetTime = "2018-08-06";
 meetingId = 1;
 meetingName = 111;
 orderNumber = 20180806123546;
 state = 2;
userList
 
 meetTime会议开始时间，
 meetSite会议地点，
 meetPrice会议报名单价，
 orderNumber订单号，
 meetingId会议主键
 meetingName会议标题
 state订单状态 1未支付（下方应有前往支付的按钮，地址以后更新）2已支付3已使用4未使用（判断giveSate是否为1，如为1则下方增加转增按钮，接口以后更新）5逾期6赠送
 retcode状态码（0000代表成功，1111为参数错误，2222为未登录），
 message状态说明
 */
@property (nonatomic, strong) NSArray *list;

@property (copy, nonatomic) NSString * meetPrice;
@property (copy, nonatomic) NSString * meetSite;
@property (copy, nonatomic) NSString * meetTime;
@property (copy, nonatomic) NSString * meetingId;
@property (copy, nonatomic) NSString * meetingName;
@property (copy, nonatomic) NSString * orderNumber;
@property (copy, nonatomic) NSString * giveSate;
@property (copy, nonatomic) NSString * state;
@property (strong, nonatomic) NSMutableArray * userList;


@end
