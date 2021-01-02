//
//  GroupListSectionHeaderView.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ GroupListSectionAction)();

@interface GroupListSectionHeaderView : UITableViewHeaderFooterView

- (void)configWithData:(GroupInfoModel *)data action:(GroupListSectionAction)action;

@end

NS_ASSUME_NONNULL_END
