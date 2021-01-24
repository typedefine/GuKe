//
//  ManageRightPopupCell.h
//  GuKe
//
//  Created by yb on 2021/1/22.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ManageRightPopupCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface ManageRightPopupCell : UITableViewCell

- (void)configWithData:(ManageRightPopupCellModel *)data;

@end

NS_ASSUME_NONNULL_END
