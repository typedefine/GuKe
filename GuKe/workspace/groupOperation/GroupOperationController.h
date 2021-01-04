//
//  GroupOperationController.h
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "BaseViewController.h"
@class GroupInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface GroupOperationController : BaseViewController

@property (nonatomic, strong, nonnull) GroupInfoModel *groupInfo;
@property (nonatomic, strong, nonnull) UIViewController *targetController;

@end

NS_ASSUME_NONNULL_END
