//
//  InfoThreeTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "InfoThreeTableViewCell.h"

@implementation InfoThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnOne setImage:[UIImage imageNamed:@"性别_未选中"] forState:normal];
    [self.btnOne setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
    
    [self.btnTwo setImage:[UIImage imageNamed:@"性别_未选中"] forState:normal];
    [self.btnTwo setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
