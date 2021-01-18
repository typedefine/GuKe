//
//  WYYChoseGroupNumberTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/22.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYChoseGroupNumberTableViewCell.h"

@implementation WYYChoseGroupNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.cornerRadius = 18.0;
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(35);
    }];
    
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.imgView.mas_right).offset(IPHONE_X_SCALE(12));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
