//
//  MsgDatePickerController.h
//  GuKe
//
//  Created by yb on 2021/2/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgDatePickerController : BaseViewController

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) void (^ selectedDate)(NSString *date);

@end

NS_ASSUME_NONNULL_END
