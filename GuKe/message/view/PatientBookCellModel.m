//
//  PatientCellModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientBookCellModel.h"
#import "PatientMessageModel.h"

@implementation PatientBookCellModel

- (void)setModel:(PatientMessageModel *)model
{
    if (_model == model || !model) return;
    _model = model;
    self.patientName = model.realName;
    self.content = model.content;
    [self updateMedicalTime:model.medicalTime];
}

- (void)updateMedicalTime:(NSString *)timeInterval
{
    if (timeInterval.isValidStringValue && timeInterval.doubleValue > 0) {
        self.replyTitle =  @"已回复";
        self.content = [NSString stringWithFormat:@"预约时间：%@",[Tools dateFormatInTheFutureWithTimeInterval:timeInterval]];
    }else{
        self.replyTitle =  @"回复";
    }
    
}

@end
