//
//  WYYGroupThreeTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/16.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYGroupThreeTableViewCell.h"

@implementation WYYGroupThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 22.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
