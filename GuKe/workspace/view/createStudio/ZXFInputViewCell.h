//
//  ZXFInputViewCell.h
//  GuKe
//
//  Created by yb on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ inputAction)(NSString *text);

@interface ZXFInputViewCell : UITableViewCell

- (void)configureWithTitle:(NSString *)title content:(NSString *)content input:(inputAction)input;

@end

NS_ASSUME_NONNULL_END

