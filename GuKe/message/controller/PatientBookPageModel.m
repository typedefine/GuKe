//
//  PatientBookPageModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientBookPageModel.h"

@implementation PatientBookPageModel

- (void)configureWithData:(NSArray *)data
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary *item in data) {
        PatientMessageModel *model = [PatientMessageModel mj_objectWithKeyValues:item];
        PatientBookCellModel *cellModel = [[PatientBookCellModel alloc] init];
        cellModel.model = model;
        [list addObject:cellModel];
    }
    self.cellModelList = [list copy];
}

@end
