//
//  WYYSouSuoYishengTableViewCell.h
//  GuKe
//
//  Created by yu on 2018/1/16.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYYSearchYishengModel.h"
@interface WYYSouSuoYishengTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLab;
@property (weak, nonatomic) IBOutlet UILabel *yiyuanLab;
@property (weak, nonatomic) IBOutlet UILabel *keshiLab;
@property (nonatomic,strong)WYYSearchYishengModel *model;
- (void)setModel:(WYYSearchYishengModel *)model;
@end
