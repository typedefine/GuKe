//
//  GroupVideoListView.h
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMModel;
NS_ASSUME_NONNULL_BEGIN

typedef void (^ GroupVideoClickedHandler)(DMModel *model);

@interface GroupVideoListView : UIView

- (void)configWithData:(id)data clicked:(GroupVideoClickedHandler)clicked collapse:(void (^)(void))collapse;

@end

NS_ASSUME_NONNULL_END
