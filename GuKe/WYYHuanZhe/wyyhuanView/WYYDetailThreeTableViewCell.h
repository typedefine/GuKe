//
//  WYYDetailThreeTableViewCell.h
//  GuKe
//
//  Created by yu on 2018/1/31.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYYDetailHuanModel.h"
@interface WYYDetailThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (nonatomic,strong)WYYDetailHuanModel *model;
- (void)setModel:(WYYDetailHuanModel *)model;
@end
