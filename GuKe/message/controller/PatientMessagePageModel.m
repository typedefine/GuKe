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
        PatientMessageModel *model = [[PatientMessageModel alloc] init];
        [list addObject:model];
    }
    self.cellModelList = [list copy];
}

- (void)setModelList:(NSArray * _Nonnull)modelList
{
    if (_modelList == modelList) return;
    _modelList = modelList;
    [modelList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

@end
