//
//  ReplyPatientBookTimePopover.h
//  GuKe
//
//  Created by 莹宝 on 2020/9/3.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PatientMessageModel;
typedef void (^ ReplyPatientBookTimeHandler)(PatientMessageModel *model, NSDate *date);

@interface ReplyPatientBookTimePopover : UIView

- (void)showWithData:(PatientMessageModel *)data reply:(ReplyPatientBookTimeHandler)reply;

@end

NS_ASSUME_NONNULL_END
