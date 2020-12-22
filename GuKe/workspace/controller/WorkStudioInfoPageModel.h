//
//  WorkGroupInfoPageModel.h
//  GuKe
//
//  Created by yb on 2020/11/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandTextCellModel.h"
#import "UserInfoModel.h"
#import "GroupInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkStudioInfoPageModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, strong) GroupInfoModel *model;
@property (nonatomic, strong) ExpandTextCellModel *infoCellModel;

@property (nonatomic, strong) NSArray<UserInfoModel *> *members;

- (void)configareWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
