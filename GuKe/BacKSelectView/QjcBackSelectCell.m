//
//  QjcBackSelectCell.m
//  GuKe
//
//  Created by MYMAc on 2018/5/11.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "QjcBackSelectCell.h"

@implementation QjcBackSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utile makeCorner:2 view:self.YuanView];
    [Utile makeCorner:10 view:self.PlayingView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
