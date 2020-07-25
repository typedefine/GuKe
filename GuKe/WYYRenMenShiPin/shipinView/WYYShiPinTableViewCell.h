//
//  WYYShiPinTableViewCell.h
//  GuKe
//
//  Created by yu on 2018/1/19.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYYShiPinModel.h"
@interface WYYShiPinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *numImg;
@property (nonatomic,strong)WYYShiPinModel *model;
- (void)setModel:(WYYShiPinModel *)model;
@end
