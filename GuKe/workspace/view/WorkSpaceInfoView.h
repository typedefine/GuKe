//
//  WorkSpaceView.h
//  GuKe
//
//  Created by yb on 2020/11/29.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkSpaceInfoViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceInfoView : UIView

- (void)configareWithData:(WorkSpaceInfoViewModel *)data;

@end

NS_ASSUME_NONNULL_END
