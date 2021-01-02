//
//  WorkGroupInfoPageModel.h
//  GuKe
//
//  Created by yb on 2020/12/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "GroupInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupInfoPageModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, strong) NSArray<UserInfoModel *> *members;
@property (nonatomic, strong) GroupInfoModel *model;

- (void)configareWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
