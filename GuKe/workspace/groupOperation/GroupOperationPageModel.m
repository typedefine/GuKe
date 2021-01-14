//
//  GroupOperationPageModel.m
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupOperationPageModel.h"

@implementation GroupOperationPageModel

- (NSArray<GroupOperationItemModel *> *)items
{
    if (!_items) {
        NSArray *titles = @[@"工作室介绍", @"创建群组", @"成员管理", @"移交管理权限"];
        NSArray *imgPaths = @[@"group_info", @"group_create", @"group_invite", @"group_transfer"];
        NSMutableArray *targetList = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i=0; i<titles.count; i++) {
            GroupOperationItemModel *item = [[GroupOperationItemModel alloc] init];
            item.type = GroupOperationType_Introduce+i;
            item.name = titles[i];
            item.imagePath = imgPaths[i];
            [targetList addObject:item];
        }
        _items = [targetList copy];
    }
    return _items;
}

- (void)setIsStudio:(BOOL)isStudio
{
    _isStudio = isStudio;
    if (!isStudio) {
        NSMutableArray<GroupOperationItemModel *> *sourceList = [self.items mutableCopy];
        sourceList[0].name = @"工作组介绍";
        [sourceList removeObjectAtIndex:1];
        [sourceList removeLastObject];
        _items = [sourceList copy];
    }
}

@end
