//
//  WorkGroupsCell.h
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkGroupTitleView.h"
@class WorkGroupItemCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupsFooter : UIView

@property (nonatomic, strong) WorkGroupTitleView *titleView;

- (void)configureWithTarget:(id)target action:(SEL)action groups:(NSArray<WorkGroupItemCellModel *> *)groups;

@end

NS_ASSUME_NONNULL_END
