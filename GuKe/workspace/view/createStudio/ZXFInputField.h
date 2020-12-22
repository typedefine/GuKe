//
//  ZXFInputField.h
//  GuKe
//
//  Created by saas on 2020/12/21.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXFInputField : UIView

- (void)configWithTitle:(NSString *)title
            placeholder:(NSString *)placeholder
             completion:(void (^)(NSString *text))completion;

@end

NS_ASSUME_NONNULL_END
