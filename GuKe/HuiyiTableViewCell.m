//
//  HuiyiTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "HuiyiTableViewCell.h"

@implementation HuiyiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab.textColor = titColor;
//    self.titleLab.font = Font14;
    self.namelAB.textColor = detailTextColor;
//    self.namelAB.font = Font12;
    self.TimeLab.textColor = detailTextColor;
//    self.TimeLab.font = Font12;
    self.addressLab.textColor = detailTextColor;
//    self.addressLab.font = Font12;
    self.imageHeightConstraint.constant = ScreenWidth*(3/5.0);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
