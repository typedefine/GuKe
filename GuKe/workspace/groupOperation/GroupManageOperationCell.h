//
//  GroupManageCell.h
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupOperationItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface GroupManageOperationCell : UITableViewCell

- (void)configWithData:(GroupOperationItemModel *)data;

@end

NS_ASSUME_NONNULL_END
