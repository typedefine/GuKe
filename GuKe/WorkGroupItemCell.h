//
//  WorkGroupCollectionViewCell.h
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkGroupItemCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupItemCell : UICollectionViewCell

- (void)configCellWithData:(WorkGroupItemCellModel *)dataModel;

@end

NS_ASSUME_NONNULL_END
