//
//  PatientMsgChatPageModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMsgChatPageModel.h"

@implementation PatientMsgChatPageModel

- (void)configureWithData:(NSArray *)data
{
    NSMutableArray<PatientMsgChatCellModel *> *list = [NSMutableArray arrayWithCapacity:data.count];
    PatientMsgChatCellModel *firstDoctorCellModel;
    CGFloat contentMaxWidth = ScreenWidth-30-30-30;
    UIFont *contentFont = [UIFont systemFontOfSize:14];
    CGFloat otherHeight =  30 + 10 + 15 +15;
    for (NSDictionary *item in data) {
        PatientMsgChatModel *model = [PatientMsgChatModel mj_objectWithKeyValues:item];
        PatientMsgChatCellModel *cellModel = [[PatientMsgChatCellModel alloc] init];
        cellModel.model = model;
        CGFloat contentHeight = [Tools sizeOfText:model.content andMaxSize:CGSizeMake(contentMaxWidth, CGFLOAT_MAX) andFont:contentFont].height;
        cellModel.height = contentHeight + otherHeight;
        if ([model.sender isEqualToString:self.recipient]) {
            cellModel.isPatient = YES;
        }else if(!firstDoctorCellModel){
            firstDoctorCellModel = cellModel;
        }
        [list addObject:cellModel];
    }
    if (firstDoctorCellModel) {
        firstDoctorCellModel.extra = @"填写就诊信息";
        firstDoctorCellModel.height += 40;
    }
    self.cellModelList = [list copy];
}

@end
