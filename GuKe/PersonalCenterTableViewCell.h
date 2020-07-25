//
//  PersonalCenterTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@protocol PersonalCenterDelegate <NSObject>
@required
//
-(void)personalCenterShowDoctorDetailInfo;
//进入到聊天消息列表
-(void)personalCenterShowDoctorChatHistory;
@end

@interface PersonalCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifyImageView;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *letterButton;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pCLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidthConstraint;
@property (nonatomic ,strong) UserInfoModel *model;
@property (nonatomic ,weak)id<PersonalCenterDelegate>delegate;
@end
