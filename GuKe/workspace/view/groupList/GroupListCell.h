//
//  GroupListCell.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface GroupListCell : UITableViewCell

- (void)configWithData:(GroupInfoModel *)data;

@end

NS_ASSUME_NONNULL_END
