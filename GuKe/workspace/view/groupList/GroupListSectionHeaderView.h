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

@interface GroupListSectionHeaderView : UITableViewHeaderFooterView

- (void)configWithData:(GroupUnionInfoModel *)data;

@end

NS_ASSUME_NONNULL_END
