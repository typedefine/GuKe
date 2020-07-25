//
//  OperationInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "OperationInfoTableViewCell.h"

@implementation OperationInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(OperationInfoModel *)model{
    _model = model;
    self.doctorNameLabel.text = [NSString changeNullString:self.model.doctor];
    self.dateLabel.text = [NSString changeNullString:self.model.surgeryTime];
    self.typeLabel.text = [NSString changeNullString:self.model.anesthesiaName];
    self.operationNameLabel.text = [NSString changeNullString:self.model.surgeryName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
