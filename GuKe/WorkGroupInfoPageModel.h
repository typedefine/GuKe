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
//@class UserInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupInfoPageModel : NSObject

@property (nonatomic, strong) ExpandTextCellModel *infoCellModel;

@property (nonatomic, strong) NSArray<UserInfoModel *> *members;

- (void)configareWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
