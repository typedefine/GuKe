//
//  ZJNSignUpMeetingInfoTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/11/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNMeetingInfoModel.h"
@interface ZJNSignUpMeetingInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *meetingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *admineNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic ,strong)ZJNMeetingInfoModel *model;

@property (weak, nonatomic) IBOutlet UILabel *LookTimeLB;

@end
