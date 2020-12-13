//
//  WorkGroupCollectionViewCell.h
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WorkStudioItemCell : UICollectionViewCell

- (void)configCellWithData:(GroupInfoModel *)dataModel;

@end

NS_ASSUME_NONNULL_END
