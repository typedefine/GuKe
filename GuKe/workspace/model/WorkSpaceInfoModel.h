//
//  WorkSpaceInfoModel.h
//  GuKe
//
//  Created by yb on 2021/1/2.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GJObject.h"
@class GroupInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceInfoModel : GJObject

@property (nonatomic, copy) NSString *headerImgUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray<GroupInfoModel *> *groups;

@property (nonatomic, assign) NSInteger status;//1:未开通任何工作室 2：已加入工作室 3：创建审核中 4.加入申请审核中
@property (nonatomic, copy) NSString *retcode;
@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
