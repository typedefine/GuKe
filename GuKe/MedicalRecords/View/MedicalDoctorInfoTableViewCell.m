//
//  MedicalDoctorInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MedicalDoctorInfoTableViewCell.h"

@implementation MedicalDoctorInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MedicalRecordsModel *)model{
    _model = model;
    self.hospitalNameLabel.text = [NSString changeNullString:self.model.hospitalName];
    self.roomLabel.text = [NSString changeNullString:self.model.deptName];
    self.doctorNameLabel.text = self.model.doctorName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
