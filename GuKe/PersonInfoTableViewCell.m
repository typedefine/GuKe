//
//  PersonInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "PersonInfoTableViewCell.h"

@implementation PersonInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = Font14;
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.layer.masksToBounds = YES;
    self.redView.layer.cornerRadius = 7.5;
    // Initialization code
    
//    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(IPHONE_X_SCALE(13));
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
