//
//  ZXFInputFieldCell.h
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXFInputBaseCell.h"
//@class ZXFInputBaseCell;

NS_ASSUME_NONNULL_BEGIN

@interface ZXFInputFieldCell : ZXFInputBaseCell

- (void)configWithTitle:(NSString *)title
            placeholder:(NSString *)placeholder
             completion:(void (^)(NSString *text))completion;

@end

NS_ASSUME_NONNULL_END
