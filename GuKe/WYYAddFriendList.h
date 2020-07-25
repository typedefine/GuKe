//
//  WYYAddFriendList.h
//  GuKe
//
//  Created by yu on 2018/1/24.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYYAddFriendList : NSObject
@property (nonatomic,strong)NSString *userid;//环信账户
@property (nonatomic,strong)NSString *state;//1患者0医生
@property (nonatomic,strong)NSString *content;//申请理由
@property (nonatomic,strong)NSString *userName;//姓名
@property (nonatomic,strong)NSString *portrait;//头像路径

@end
