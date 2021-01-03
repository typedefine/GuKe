//
//  GroupOperationController.h
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupOperationController : BaseViewController

@property (nonatomic, assign) BOOL isStudio;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, strong) UIViewController *targetController;

@end

NS_ASSUME_NONNULL_END
