//
//  GroupInfoModel.h
//  GuKe
//
//  Created by yb on 2020/12/6.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupInfoModel : GJObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, assign) NSInteger groupid;
@property (nonatomic, copy) NSString *groupname;
@property (nonatomic, copy) NSString *portrait;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *countTitle;

@end

NS_ASSUME_NONNULL_END
