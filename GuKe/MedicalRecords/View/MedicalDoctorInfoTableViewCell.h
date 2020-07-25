//
//  MedicalDoctorInfoTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalRecordsModel.h"
@interface MedicalDoctorInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
@property (nonatomic ,strong)MedicalRecordsModel *model;
@end
