//
//  InfoFourTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "InfoFourTableViewCell.h"

@implementation InfoFourTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.BtnOne.layer.masksToBounds = YES;
    self.BtnOne.layer.cornerRadius = 2;
    self.BtnOne.backgroundColor = greenC;
    
    self.BtnTwo.layer.masksToBounds = YES;
    self.BtnTwo.layer.cornerRadius = 2;
    self.BtnTwo.backgroundColor = greenC;
    
    self.BtnThree.layer.masksToBounds = YES;
    self.BtnThree.layer.cornerRadius = 2;
    self.BtnThree.backgroundColor = greenC;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
