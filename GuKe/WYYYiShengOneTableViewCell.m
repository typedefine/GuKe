//
//  WYYYiShengOneTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/17.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYYiShengOneTableViewCell.h"

@implementation WYYYiShengOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 20;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
