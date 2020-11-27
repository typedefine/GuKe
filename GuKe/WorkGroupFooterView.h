//
//  WorkGroupFooterView.h
//  GuKe
//
//  Created by yb on 2020/11/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GroupMembersView;
//@class WorkGroupSupporterView;
#import "GroupMembersView.h"
#import "WorkGroupSupporterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupFooterView : UIView

@property (nonatomic, strong) GroupMembersView *membersview;
@property (nonatomic, strong) WorkGroupSupporterView *supporterView;

@end

NS_ASSUME_NONNULL_END
