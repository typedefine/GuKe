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
    self.replyTitle = model.isRead == 1 ? @"已回复" : @"回复";
}

@end
