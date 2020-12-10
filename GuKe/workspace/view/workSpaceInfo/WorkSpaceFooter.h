//
//  WorkGroupsCell.h
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkGroupsTitleView.h"
@class GroupInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceFooter : UIView

@property (nonatomic, strong) WorkGroupsTitleView *titleView;

- (void)configureWithTarget:(id)target action:(SEL)action groups:(NSArray<GroupInfoModel *> *)groups;

@end

NS_ASSUME_NONNULL_END
