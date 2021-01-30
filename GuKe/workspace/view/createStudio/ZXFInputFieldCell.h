//
//  ZXFInputFieldCell.h
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZXFInputFieldCell : UITableViewCell

- (void)configWithTitle:(NSString *)title
            placeholder:(NSString *)placeholder
                content:(NSString *)content
             completion:(void (^)(NSString *text))completion;

@end

NS_ASSUME_NONNULL_END
