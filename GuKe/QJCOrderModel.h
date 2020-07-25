//
//  QJCOrderModel.h
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJCOrderModel : NSObject
/**
 
 userList会议报名人列表（orderUserName姓名，orderUserPhone手机号,orderCode验证码，giveSate是否本人购买0不是1是），


 
 
 giveSate = 0;
 meetingId = "<null>";
 orderCode = "";
 orderNumber = "<null>";
 orderState = 4;
 orderUserDept = "<null>";
 orderUserHos = "<null>";
 orderUserId = "<null>";
 orderUserName = "\U8d60\U900139";
 orderUserPhone = 15010573539;
 orderUserTitle = "<null>";
 spendSate = "<null>";

 */
@property(strong , nonatomic) NSString * giveSate ;
@property(strong , nonatomic) NSString * meetingId ;
@property(strong , nonatomic) NSString * orderCode ;
@property(strong , nonatomic) NSString * orderNumber ;
@property(strong , nonatomic) NSString * orderState ;
@property(strong , nonatomic) NSString * orderUserDept ;
@property(strong , nonatomic) NSString * orderUserHos ;
@property(strong , nonatomic) NSString * orderUserId ;
@property(strong , nonatomic) NSString * orderUserName ;
@property(strong , nonatomic) NSString * orderUserPhone ;
@property(strong , nonatomic) NSString * orderUserTitle ;
@property(strong , nonatomic) NSString * spendSate ;

@end
