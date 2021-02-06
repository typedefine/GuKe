//
//  MsgRecordController.h
//  GuKe
//
//  Created by yb on 2021/2/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface MsgRecordController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *groupId;

@end


NS_ASSUME_NONNULL_END
