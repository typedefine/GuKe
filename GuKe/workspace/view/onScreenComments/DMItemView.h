//
//  DMItemView.h
//  GuKe
//
//  Created by yb on 2021/1/10.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDanmakuModel;

NS_ASSUME_NONNULL_BEGIN

@interface DMItemView : UIView

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)configWithData:(FDanmakuModel *)data;

@end

NS_ASSUME_NONNULL_END
