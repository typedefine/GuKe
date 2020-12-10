//
//  WorkGroupListViewModel.m
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupListViewModel.h"


@implementation WorkGroupListViewModel

- (void)configareWithData:(NSArray *)data
{
    if (!data || [data isMemberOfClass:[NSArray class]] || data.count ==0) return;
    NSMutableArray<GroupInfoModel *> *rootList = [NSMutableArray array];
    NSMutableArray<GroupInfoModel *> *subList = [NSMutableArray array];
    for (NSDictionary *d in data) {
        
        if ([d[@"groupType"] intValue] == 1) {
            GroupUnionInfoModel *u = [GroupUnionInfoModel mj_objectWithKeyValues:d];
            [rootList addObject:u];
        }else{
            GroupInfoModel *m = [GroupInfoModel mj_objectWithKeyValues:d];
            [subList addObject:m];
        }
    }
    NSMutableArray *targetList = [NSMutableArray arrayWithCapacity:rootList.count];
    for (GroupUnionInfoModel *u  in rootList) {
        NSMutableArray *children = [NSMutableArray array];
        for (GroupInfoModel *m in subList) {
            if (u.ID == m.groupType) {
                [children addObject:m];
            }
        }
        [children sortUsingComparator:^NSComparisonResult(GroupInfoModel *obj1, GroupInfoModel *obj2) {
            return obj1.ID > obj2.ID;
        }];
        u.children = [children copy];
        [targetList addObject:u];
    }
    
    self.groupList = [targetList copy];
}

@end
