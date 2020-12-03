//
//  WorkGroupsInfoPageModel.h
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkSpaceInfoViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceInfoPageModel : NSObject

@property (nonatomic, strong) UIViewController *targetController;
@property (nonatomic, copy) NSString *sessionid;
@property (nonatomic, strong) WorkSpaceInfoViewModel *infoViewModel;

- (void)configareWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
