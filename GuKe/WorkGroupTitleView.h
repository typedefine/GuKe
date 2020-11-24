//
//  WorkGroupTitleView.h
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupTitleView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) void (^ action)();

@end

NS_ASSUME_NONNULL_END
