//
//  StudioInfoModel.h
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudioInfoModel : GJObject

@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, assign) NSInteger groupid;
@property (nonatomic, copy) NSString *groupname;;
@property (nonatomic, copy) NSString *portrait;

@end

NS_ASSUME_NONNULL_END
