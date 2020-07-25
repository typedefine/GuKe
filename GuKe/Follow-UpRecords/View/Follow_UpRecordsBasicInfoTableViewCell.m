//
//  Follow-UpRecordsBasicInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "Follow_UpRecordsBasicInfoTableViewCell.h"

@implementation Follow_UpRecordsBasicInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(Follow_UpRecordsModel *)model{
    _model = model;
    self.nameLabel.text = [NSString changeNullString:self.model.patientName];
    NSString *gender = [NSString changeNullString:self.model.gender];
    if ([gender isEqualToString:@"1"]) {
        self.sexLabel.text = @"男";
    }else if ([gender isEqualToString:@"0"]){
        self.sexLabel.text = @"女";
    }else{
        self.sexLabel.text = gender;
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%@岁",[NSString changeNullString:self.model.age]];
    
    self.nationLabel.text = model.national;
    
    self.hospitalNumberLabel.text = [NSString changeNullString:self.model.hospNum];
    
    self.phoneLabel.text = [NSString changeNullString:self.model.phone];
}
- (IBAction)phoneButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(makeAPhoneWithNumber:)]) {
        [self.delegate makeAPhoneWithNumber:self.model.phone];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
