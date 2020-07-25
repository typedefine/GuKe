//
//  SuiFangTableViewCell.h
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuiFangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIImageView *suiFangImg;
@property (weak, nonatomic) IBOutlet UILabel *zhangduanLab;
@property (weak, nonatomic) IBOutlet UIButton *zuifangBtn;
@property (weak, nonatomic) IBOutlet UILabel *shoushuTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@end
