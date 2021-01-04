//
//  ShareFileCell.h
//  GuKe
//
//  Created by yb on 2021/1/5.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareFileItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface ShareFileCell : UITableViewCell

- (void)configWithData:(ShareFileItemModel *)data;

@end

NS_ASSUME_NONNULL_END
