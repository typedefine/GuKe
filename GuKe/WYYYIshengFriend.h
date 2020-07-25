//
//  WYYYIshengFriend.h
//  GuKe
//
//  Created by yu on 2018/1/20.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYYYIshengFriend : NSObject
/*
 name = "\U519c\U6751\U8001\U53ef\U7231";
 patient = 1;
 portrait = "";
 userId = 8ac2828361080ff701610863ab4b000f;
 */
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *patient;
@property (nonatomic,strong)NSString *portrait;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *doctorId;

@property (nonatomic,strong)NSString *groupid;
@property (nonatomic,strong)NSString *groupname;

@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *gender;
@end
