//
//  GroupInfoModel.h
//  GuKe
//
//  Created by yb on 2020/12/6.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"
@class UserInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface GroupInfoModel : GJObject

@property (nonatomic, assign) NSInteger chatgroupsId;
@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, assign) NSInteger groupType;//roupType为1的是工作室，groupType>1的是工作组
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupPortrait;
@property (nonatomic, copy) NSString *groupOwner;
@property (nonatomic, assign) NSInteger groupStatus;
@property (nonatomic, copy) NSString *groupDesc;

@property (nonatomic, assign) NSInteger joinStatus;
//@property (nonatomic, assign) BOOL isOwner;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *countTitle;

@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@property (nonatomic, strong) NSArray<GroupInfoModel *> *chatroom;

@property (nonatomic, copy) NSString *sponsorName;
@property (nonatomic, copy) NSString *sponsorLogo;
@property (nonatomic, copy) NSString *sponsorUrl;

@property (nonatomic, assign) BOOL isManager;

@end

NS_ASSUME_NONNULL_END
