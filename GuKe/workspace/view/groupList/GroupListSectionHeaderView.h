//
//  GroupListSectionHeaderView.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupUnionInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ GroupListSectionAction)();

@interface GroupListSectionHeaderView : UITableViewHeaderFooterView

- (void)configWithData:(GroupUnionInfoModel *)data action:(GroupListSectionAction)action;

@end

NS_ASSUME_NONNULL_END
