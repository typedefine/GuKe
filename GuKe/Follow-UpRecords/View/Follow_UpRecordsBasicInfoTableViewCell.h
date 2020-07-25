//
//  Follow-UpRecordsBasicInfoTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Follow_UpRecordsModel.h"
@protocol follow_UpRecordsBasicInfoDelegate<NSObject>
@required
-(void)makeAPhoneWithNumber:(NSString *)phoneNumber;

@end
@interface Follow_UpRecordsBasicInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic ,strong)Follow_UpRecordsModel *model;
@property (nonatomic ,weak)id<follow_UpRecordsBasicInfoDelegate>delegate;
@end
