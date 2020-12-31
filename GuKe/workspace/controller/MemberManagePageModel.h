//
//  MemberManagePageModel.h
//  GuKe
//
//  Created by saas on 2020/12/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MemberManagePageModel : NSObject

@property(nonatomic, strong) NSArray<UserInfoModel *> *members;

@end

NS_ASSUME_NONNULL_END
