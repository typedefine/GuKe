//
//  WYYMainGroupTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/15.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYMainGroupTableViewCell.h"

@implementation WYYMainGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.GroupImg.layer.masksToBounds = YES;
    self.GroupImg.layer.cornerRadius = 18.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
