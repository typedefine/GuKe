//
//  MedicalLifeSignsTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalRecordsModel.h"
@interface MedicalLifeSignsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *breathLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapLabel;
@property (weak, nonatomic) IBOutlet UILabel *bpLabel;
@property (nonatomic ,strong)MedicalRecordsModel *model;
@end
