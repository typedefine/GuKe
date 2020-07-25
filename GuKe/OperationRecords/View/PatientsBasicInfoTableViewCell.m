//
//  PatientsBasicInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "PatientsBasicInfoTableViewCell.h"

@implementation PatientsBasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(OperationRecordInfoModel *)model{
    _model = model;
    self.nameLabel.text = [NSString changeNullString:self.model.patientName];
    if ([self.model.gender isEqualToString:@"1"]) {
        self.sexLabel.text = @"男";
    }else if ([self.model.gender isEqualToString:@"0"]){
        self.sexLabel.text = @"女";
    }else{
        self.sexLabel.text = @"";
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@周岁",[NSString changeNullString:self.model.age]];
    self.numberLabel.text = [NSString changeNullString:self.model.hospNum];
    self.hospitalNameLabel.text = [NSString changeNullString:self.model.hospitalName];
    self.roomLabel.text = [NSString changeNullString:self.model.deptName];
    self.doctorNameLabel.text = [NSString changeNullString:self.model.doctorName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
