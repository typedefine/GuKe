//
//  WYYHuanZheListTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/29.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYHuanZheListTableViewCell.h"

@implementation WYYHuanZheListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 18.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
