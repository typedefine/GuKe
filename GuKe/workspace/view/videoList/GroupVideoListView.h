//
//  GroupVideoListView.h
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ GroupVideoClickedHandler)(NSInteger index);

@interface GroupVideoListView : UIView

- (void)configWithData:(id)data clicked:(GroupVideoClickedHandler)clicked;

@end

NS_ASSUME_NONNULL_END
