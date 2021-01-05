//
//  GuKeCache.h
//  GuKe
//
//  Created by yb on 2021/1/3.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *kWorkStudioGroup_cache_key = @"WorkStudio_group_list_data";
static const NSString  __strong * _Nonnull kUserInfo_cache_Key = @"user_info_model";

@interface GuKeCache : NSCache

@property (nonatomic, strong) UserInfoModel *user;
@property (nonatomic, copy) NSString *sessionId;

+ (instancetype)shareCache;

- (void)loadLocalInfo;
- (void)clean;

- (void)loadWorkSpaceDataWithSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

@end

NS_ASSUME_NONNULL_END
