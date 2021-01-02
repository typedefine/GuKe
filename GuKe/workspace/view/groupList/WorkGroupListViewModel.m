//
//  WorkGroupListViewModel.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupListViewModel.h"

@implementation WorkGroupListViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _groupList = @[];
    }
    return self;
}

- (void)configareWithData:(NSArray *)data
{
    if (!data || [data isMemberOfClass:[NSArray class]] || data.count ==0) return;
    NSMutableArray<GroupInfoModel *> *targetList = [NSMutableArray array];
    for (NSDictionary *d in data) {
        GroupInfoModel *u = [GroupInfoModel mj_objectWithKeyValues:d];
        [targetList addObject:u];
    }
    self.groupList = [targetList copy];
}

@end
