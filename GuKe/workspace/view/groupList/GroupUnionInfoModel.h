//
//  GroupUnionInfoModel.h
//  GuKe
//
//  Created by yb on 2020/12/6.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupUnionInfoModel : GroupInfoModel

@property (nonatomic, strong) NSArray<GroupInfoModel *> *children;
@property (nonatomic, assign) NSInteger newCount;

@end

NS_ASSUME_NONNULL_END
