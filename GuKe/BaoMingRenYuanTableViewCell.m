//
//  BaoMingRenYuanTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "BaoMingRenYuanTableViewCell.h"

@implementation BaoMingRenYuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLab.textColor = SetColor(0x1a1a1a);
    self.addressLab.textColor = detailTextColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
