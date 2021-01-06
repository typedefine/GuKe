//
//  GroupVideoModel.h
//  GuKe
//
//  Created by yb on 2021/1/7.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GJObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupVideoModel : GJObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, copy) NSString *doctorName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, assign) NSInteger createTime;

@end

NS_ASSUME_NONNULL_END
