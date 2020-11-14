//
//  WorkGroupsInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupsInfoPageModel.h"

@implementation WorkGroupsInfoPageModel

- (instancetype)init
{
    if (self = [super init]) {
        self.workSpacetitle = @"骨先生工作站";
        self.workGrouptitle = @"工作室";
        self.addGroupActionTitle = @"申请开通工作室";
    }
    return self;
}

- (WorkSpaceInfoCellModel *)workSpaceModel
{
    if (!_workSpaceModel) {
        _workSpaceModel = [[WorkSpaceInfoCellModel alloc] init];
    }
    return _workSpaceModel;
}


@end
