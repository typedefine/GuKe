//
//  GroupMemberView.h
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel, GroupMembersView;

NS_ASSUME_NONNULL_BEGIN

@protocol GroupMembersViewDelegate <NSObject>

@required

- (NSArray<UserInfoModel *> *)membersInView:(GroupMembersView *)membersView;

@optional
- (NSString *)titleInMemberView:(GroupMembersView *)membersView;
- (CGFloat)minimumLineSpacingInMemberView:(GroupMembersView *)membersView;
- (CGFloat)minimumInteritemSpacingInMemberView:(GroupMembersView *)membersView;
- (CGSize)itemSizeInMemberView:(GroupMembersView *)membersView;
- (void)memberView:(GroupMembersView *)membersView didSelectAtIndex:(NSInteger)index;

@end

@interface GroupMembersView : UIView

//@property (nonatomic, copy) NSString *title;
//
//- (void)configureWithTarget:(id)target action:(SEL)action members:(NSArray<UserInfoModel *> *)members;

@property (nonatomic, weak) id<GroupMembersViewDelegate> delegate;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
