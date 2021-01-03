//
//  GuKeCache.h
//  GuKe
//
//  Created by yb on 2021/1/3.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static const NSString *kWorkStudioGroup = @"WorkStudio_group_list_data";

@interface GuKeCache : NSCache

@property (nonatomic, copy) NSString *sessionId;

+ (instancetype)shareCache;

- (void)loadLocalInfo;

- (void)loadWorkSpaceDataWithSuccess:(HttpSuccess)success failure:(HttpFailure)failure;

@end

NS_ASSUME_NONNULL_END
