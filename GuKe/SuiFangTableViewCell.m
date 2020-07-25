//
//  SuiFangTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SuiFangTableViewCell.h"

@implementation SuiFangTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 25;
    
    self.nameLab.textColor = titColor;
//    self.nameLab.font = Font14;
    self.timeLab.textColor = detailTextColor;
//    self.timeLab.font = Font12;
    self.phoneLab.textColor = detailTextColor;
//    self.phoneLab.font = Font12;
    self.zhangduanLab.textColor = detailTextColor;
//    self.zhangduanLab.font = Font12;
    self.shoushuTimeLab.textColor = detailTextColor;
//    self.shoushuTimeLab.font = Font12;
//    self.zuifangBtn.titleLabel.font = Font12;
    self.zuifangBtn.backgroundColor = greenC;
    self.zuifangBtn.layer.masksToBounds = YES;
    self.zuifangBtn.layer.cornerRadius = 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
