//
//  WoDeShouShuTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "WoDeShouShuTableViewCell.h"

@implementation WoDeShouShuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 22.5;
//    self.nameLab.font = Font14;
//    self.numLab.font = Font12;
//    self.buweiLab.font = Font12;
//    self.timeLab.font = Font12;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
