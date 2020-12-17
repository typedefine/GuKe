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
#import "WorkStudioSupporterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkStudioFooterView : UIView

@property (nonatomic, strong) GroupMembersView *membersView;
@property (nonatomic, strong) WorkStudioSupporterView *supporterView;

@end

NS_ASSUME_NONNULL_END
