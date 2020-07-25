//
//  OperationInfoTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationInfoModel.h"
@interface OperationInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationNameLabel;
@property (nonatomic ,strong)OperationInfoModel *model;
@end
