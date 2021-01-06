//
//  GroupVideoCell.h
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupVideoCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface GroupVideoCell : UICollectionViewCell

- (void)configWithData:(GroupVideoCellModel *)data;

@end

NS_ASSUME_NONNULL_END
