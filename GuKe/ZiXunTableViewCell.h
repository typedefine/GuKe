//
//  ZiXunTableViewCell.h
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiXunlistModel.h"
@interface ZiXunTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic,strong)ZiXunlistModel *model;
@end
