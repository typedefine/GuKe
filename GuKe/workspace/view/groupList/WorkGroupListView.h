//
//  WorkGroupListView.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkSpaceInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupListView : UIView

- (void)configareWithTargetController:(UIViewController*)targetController data:(WorkSpaceInfoModel *)data;

@end

NS_ASSUME_NONNULL_END
