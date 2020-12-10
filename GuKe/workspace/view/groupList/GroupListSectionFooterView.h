//
//  GroupListSectionFooterView.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupListSectionFooterView : UITableViewHeaderFooterView

//@property (nonatomic, copy) NSString *newFriendNum;
//@property (nonatomic, weak) id target;
//@property (nonatomic) SEL action;

- (void)configWithTarget:(id)target action:(SEL)action newFriendsNum:(NSString *)newFriendsNum;

@end

NS_ASSUME_NONNULL_END
