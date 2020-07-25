//
//  InfoOneTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "InfoOneTableViewCell.h"

@implementation InfoOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.BtnOne setImage:[UIImage imageNamed:@"性别_未选中"] forState:normal];
    [self.BtnOne setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
//    self.BtnOne.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
//    self.BtnOne.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    [self.BtnTwo setImage:[UIImage imageNamed:@"性别_未选中"] forState:normal];
    [self.BtnTwo setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
    
    
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
