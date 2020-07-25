//
//  ZJNSingUpMeetingPeopleTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNMeetingInfoModel.h"
@interface ZJNSingUpMeetingPeopleTableViewCell : UITableViewCell
@property (nonatomic ,strong)UILabel *countLabel;
@property (nonatomic ,strong)UIButton *moreButton;
@property (nonatomic ,strong)ZJNMeetingInfoModel *model;
@end
