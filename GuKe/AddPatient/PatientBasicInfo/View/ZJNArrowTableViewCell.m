//
//  ZJNArrowTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/30.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNArrowTableViewCell.h"

@implementation ZJNArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.hidden = NO  ;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
