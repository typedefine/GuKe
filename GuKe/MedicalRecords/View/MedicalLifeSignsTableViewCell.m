//
//  MedicalLifeSignsTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MedicalLifeSignsTableViewCell.h"

@implementation MedicalLifeSignsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utile makeCorner:5 view:self.tempLabel];
    [Utile makeCorner:5 view:self.breathLabel];
    [Utile makeCorner:5 view:self.tapLabel];
    [Utile makeCorner:5 view:self.bpLabel];
    // Initialization code
}
-(void)setModel:(MedicalRecordsModel *)model{
    _model = model;
    self.tempLabel.text = [NSString changeNullString:self.model.temperature];
    self.breathLabel.text = [NSString changeNullString:self.model.breathe];
    self.tapLabel.text = [NSString changeNullString:self.model.pulse];
    self.bpLabel.text = [NSString changeNullString:self.model.pressure];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
