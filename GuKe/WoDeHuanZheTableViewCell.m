//
//  WoDeHuanZheTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "WoDeHuanZheTableViewCell.h"

@implementation WoDeHuanZheTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 22.5;
    
    self.nameLab.textColor = SetColor(0x1a1a1a);
//    self.nameLab.font = Font14;
    self.zhuyuanhaoLab.textColor = SetColor(0x999999);
//    self.zhuyuanhaoLab.font = Font12;
    self.zhenduanLab.textColor = SetColor(0x999999);
//    self.zhenduanLab.font = Font12;
    self.zheLiaoLab.textColor = SetColor(0x999999);
//    self.zheLiaoLab.font = Font12;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
