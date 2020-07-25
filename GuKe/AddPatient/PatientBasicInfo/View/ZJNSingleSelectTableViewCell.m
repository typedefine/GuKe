//
//  ZJNSingleSelectTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/30.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNSingleSelectTableViewCell.h"

@implementation ZJNSingleSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)leftButtonClick:(UIButton *)sender {
    self.rightButton.selected = NO;
    self.leftButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleSelectedWithType:)]) {
        [self.delegate singleSelectedWithType:@"1"];
    }
}
- (IBAction)rightButtonClick:(id)sender {
    self.rightButton.selected = YES;
    self.leftButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleSelectedWithType:)]) {
        [self.delegate singleSelectedWithType:@"0"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
