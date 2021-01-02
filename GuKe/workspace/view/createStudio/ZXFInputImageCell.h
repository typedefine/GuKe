//
//  ZXFInputImageCell.h
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZXFInputImageCell : UITableViewCell

- (void)configureWithTarget:(UIViewController *)targetController
                      title:(NSString *)title
                   indicate:(NSString *)indicate
                 completion:(void (^)(id data))completion;

@end

NS_ASSUME_NONNULL_END
