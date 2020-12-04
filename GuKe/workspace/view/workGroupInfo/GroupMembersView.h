//
//  GroupMemberView.h
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface GroupMembersView : UIView

@property (nonatomic, copy) NSString *title;

- (void)configureWithTarget:(id)target action:(SEL)action members:(NSArray<UserInfoModel *> *)members;

@end

NS_ASSUME_NONNULL_END
