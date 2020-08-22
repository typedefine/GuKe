//
//  PatientMessageCellModel.m
//  GuKe
//
//  Created by jiangchen zhou on 2020/8/20.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMessageCellModel.h"
#import "PatientMessageModel.h"

@implementation PatientMessageCellModel

- (void)setModel:(PatientMessageModel *)model
{
    if (_model == model || !model) return;
    _model = model;
    self.patientName = model.realName;
    self.content = model.content;
    self.replyTitle = model.isRead == 1 ? @"已回复" : @"回复";
}

@end
