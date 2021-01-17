//
//  GuKeCache.m
//  GuKe
//
//  Created by yb on 2021/1/3.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GuKeCache.h"
#import "WorkSpaceInfoModel.h"

@implementation GuKeCache

+ (instancetype)shareCache
{
    static GuKeCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[GuKeCache alloc] init];
        cache.onScreenCommentsConfig = [NSMutableDictionary dictionary];
    });
    return cache;
}

- (void)loadLocalInfo
{
    _sessionId = sessionIding;
    NSDictionary *ud = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo_cache_Key];
    if (ud) {
        UserInfoModel *m = [UserInfoModel mj_objectWithKeyValues:ud];
//        [self setObject:m forKey:kUserInfo_cache_Key];
        _user = m;
    }
}

- (void)clean
{
    [_onScreenCommentsConfig removeAllObjects];
    _onScreenCommentsConfig = nil;
    _sessionId = nil;
    _user = nil;
    _spaceInfo = nil;
//    [self removeAllObjects];
}

//- (UserInfoModel *)user
//{
//    return [self objectForKey:kUserInfo_cache_Key];
//}
//
//- (void)setUser:(UserInfoModel *)user
//{
//    [self setObject:user forKey:kUserInfo_cache_Key];
//}

- (void)loadWorkSpaceDataWithSuccess:(HttpSuccess)success failure:(HttpFailure)failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_workplace];
    NSMutableDictionary *para = [@{
        @"sessionId": self.sessionId,
    } mutableCopy];
   
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        WorkSpaceInfoModel *model = [WorkSpaceInfoModel mj_objectWithKeyValues:data];
        if ([model.retcode isEqualToString:@"0000"]) {
//            [self setObject:model forKey:kWorkStudioGroup_cache_key];
            _spaceInfo = model;
        }
        if (success) {
            success(model);
        }
    } failure:failure];
}

-(void)dealloc
{
    [self clean];
}

@end
