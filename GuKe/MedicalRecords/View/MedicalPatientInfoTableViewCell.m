//
//  MedicalPatientInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MedicalPatientInfoTableViewCell.h"

@implementation MedicalPatientInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MedicalRecordsModel *)model{
    _model = model;
    self.nameLabel.text = [NSString changeNullString:self.model.patientName];
    if ([[NSString changeNullString:self.model.gender] isEqualToString:@"1"]) {
        self.sexLabel.text = @"男";
    }else if ([[NSString changeNullString:self.model.gender] isEqualToString:@"0"]){
        self.sexLabel.text = @"女";
    }else{
        self.sexLabel.text = [NSString changeNullString:self.model.gender];
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@周岁",[NSString changeNullString:self.model.age]];
    self.minZuLabel.text = [NSString changeNullString:self.model.nation];
    self.numberLabel.text = [NSString changeNullString:self.model.hospNum];
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",[NSString changeNullString:self.model.area],[NSString changeNullString:self.model.homeadress]];
    self.cardNumberLabel.text = [NSString changeNullString:self.model.idCard];
    self.startTimeLabel.text = [NSString changeNullString:self.model.intime];
    self.endTimeLabel.text = [NSString changeNullString:self.model.outtime];
    self.contactNameLabel.text = [NSString changeNullString:self.model.linkman];
    self.relationLabel.text = [NSString changeNullString:self.model.relation];
    self.phoneLabel.text = [NSString changeNullString:self.model.phone];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
