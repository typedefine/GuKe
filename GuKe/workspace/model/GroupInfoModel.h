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

//@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger groupType;//roupType为1的是工作室，groupType>1的是工作组
@property (nonatomic, assign) NSInteger groupid;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *countTitle;


@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *sponsorName;
@property (nonatomic, copy) NSString *sponsorUrl;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray *chatroom;

@end

NS_ASSUME_NONNULL_END
