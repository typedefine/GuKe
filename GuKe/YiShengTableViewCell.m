//
//  YiShengTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "YiShengTableViewCell.h"

@implementation YiShengTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLab.textColor = titColor;
    self.zhiweiLab.textColor = SetColor(0x06a27b);
    self.yiyuanLab.textColor = detailTextColor;
    self.zhuanyelab.textColor = detailTextColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
