//
//  PatientMessagePageModel.m
//  GuKe
//
//  Created by jiangchen zhou on 2020/8/20.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMessagePageModel.h"

@implementation PatientMessagePageModel


- (void)configureWithData:(NSArray *)data
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary *item in data) {
        PatientMessageModel *model = [PatientMessageModel mj_objectWithKeyValues:item];
        PatientMessageCellModel *cellModel = [[PatientMessageCellModel alloc] init];
        cellModel.model = model;
        [list addObject:cellModel];
    }
    self.cellModelList = [list copy];
}


@end
