//
//  PatientMsgChatPageModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMsgChatPageModel.h"

@implementation PatientMsgChatPageModel
{
    CGFloat _contentMaxWidth;
    UIFont *_contentFont;
    CGFloat _otherHeight;
}

-(instancetype)init
{
    if (self = [super init]) {
        _contentMaxWidth = ScreenWidth-30-30-30;
        _contentFont = [UIFont systemFontOfSize:14];
        _otherHeight =  30 + 10 + 15 +15;
    }
    return self;
}

- (void)configureWithData:(NSArray *)data
{
    NSMutableArray<PatientMsgChatCellModel *> *list = [NSMutableArray arrayWithCapacity:data.count];
    PatientMsgChatCellModel *firstDoctorCellModel;
    for (NSDictionary *item in data) {
        PatientMsgChatModel *model = [PatientMsgChatModel mj_objectWithKeyValues:item];
        PatientMsgChatCellModel *cellModel = [self buildCellModelWithData:model];
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

- (void)addData:(NSDictionary *)data
{
    NSMutableArray<PatientMsgChatCellModel *> *list = [NSMutableArray arrayWithArray:self.cellModelList];
    PatientMsgChatModel *model = [PatientMsgChatModel mj_objectWithKeyValues:data];
    PatientMsgChatCellModel *cellModel = [self buildCellModelWithData:model];
    [list addObject:cellModel];
    self.cellModelList = [list copy];
}


- (PatientMsgChatCellModel *)buildCellModelWithData:(PatientMsgChatModel *)model
{
    PatientMsgChatCellModel *cellModel = [[PatientMsgChatCellModel alloc] init];
    cellModel.model = model;
    CGFloat contentHeight = [Tools sizeOfText:model.content andMaxSize:CGSizeMake(_contentMaxWidth, CGFLOAT_MAX) andFont:_contentFont].height;
    cellModel.height = contentHeight + _otherHeight;
    return cellModel;
}



@end
