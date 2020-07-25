//
//  WYYFMDBManager.h
//  GuKe
//
//  Created by yu on 2018/1/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "WYYYIshengFriend.h"
@interface WYYFMDBManager : NSObject
+ (WYYFMDBManager *)shareWYYManager;
/**
 添加一个好友
 @param model   好友信息
 */
- (void)addFriendListModel:(WYYYIshengFriend *)model;

/**
  更新一个好友
 @param model   好友信息
 
 */
- (void)changeFriendListModel:(WYYYIshengFriend *)model;

/**
 删除一个好友
 @param model   好友信息
 
 */
- (void)deleteFriendListModel:(WYYYIshengFriend *)model;

/**
 查询一个好友
 @param model   好友信息
 
 */
- (WYYYIshengFriend *)getFriendInfoModel:(NSString *)userId;

/**
 查询一个群组信息
 @param model   好友信息
 
 */
- (WYYYIshengFriend *)getGroupInfoModel:(NSString *)groupid;


/**
 查询表单中是否有该用户信息
 
 @param user_id 用户ID
 @return 0 不存在 1存在
 */
- (BOOL)isExistInfoTable:(NSString *)userId;

/**
 查询表单中是否有该群组
 
 @param user_id 群组id
 @return 0 不存在 1存在
 */
- (BOOL)isGroupInfoTable:(NSString *)groupid;





@end
