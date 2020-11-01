//
//  DoctorChatCell.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ DoctorChatAction)();

@class PatientMsgChatCellModel;
@interface DoctorChatCell : UITableViewCell

- (void)configureCellWithData:(PatientMsgChatCellModel *)data action:(DoctorChatAction)action;

@end

NS_ASSUME_NONNULL_END
