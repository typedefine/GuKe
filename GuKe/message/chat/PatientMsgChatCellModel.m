//
//  PatientMsgChatCellModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMsgChatCellModel.h"

@implementation PatientMsgChatCellModel

- (void)setModel:(PatientMsgChatModel *)model
{
    if (_model == model || !model) return;
    _model = model;
    self.content = model.content;
    self.time = [Tools dateFormatterWithDateStringValue:model.createTime sourceFormatter:@"yyyy-MM-dd dd:mm:ss.s"];

}


@end
