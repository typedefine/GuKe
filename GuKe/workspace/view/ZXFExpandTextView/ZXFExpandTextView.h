//
//  ZXFExpandTextView.h
//  GuKe
//
//  Created by yb on 2020/11/8.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ ZXFExpandTextViewBlock)(BOOL expand);

@class ZXFExpandTextViewModel;

@interface ZXFExpandTextView : UIView

- (void)configureWithModel:(ZXFExpandTextViewModel *)model expand:(ZXFExpandTextViewBlock)expand;

@end

NS_ASSUME_NONNULL_END
