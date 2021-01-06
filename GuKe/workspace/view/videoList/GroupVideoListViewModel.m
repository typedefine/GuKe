//
//  GroupVideoListViewModel.m
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupVideoListViewModel.h"

@implementation GroupVideoListViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _items = @[];
    }
    return self;
}

- (void)configWithData:(NSArray<NSDictionary *> *)dataList
{
    if (dataList && dataList.count > 0) {
        NSMutableArray *targetArray = [NSMutableArray arrayWithCapacity:dataList.count];
        for (NSDictionary *d in dataList) {
            GroupVideoModel *m = [GroupVideoModel mj_objectWithKeyValues:d];
            GroupVideoCellModel *cm = [[GroupVideoCellModel alloc] init];
            cm.iconUrl = @"http://files.guxians.com/chatgroup/default_groupvideo.jpg";
            cm.model = m;
            [targetArray addObject:cm];
        }
        _items = [targetArray copy];
    }
}

@end
