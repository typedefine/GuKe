//
//  WorkGroupsInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoPageModel.h"
#import "WorkGroupItemCellModel.h"
#import "WorkSpaceInfoViewModel.h"

@implementation WorkSpaceInfoPageModel

- (instancetype)init
{
    if (self = [super init]) {
//        self.workSpacetitle = @"骨先生工作站";
//        self.workGrouptitle = @"工作室";
//        self.addGroupActionTitle = @"申请开通工作室";
    }
    return self;
}


- (void)configareWithData:(id)data
{
    [self.infoViewModel configareWithData:nil];
}

- (WorkSpaceInfoViewModel *)infoViewModel
{
    if (!_infoViewModel) {
        _infoViewModel = [[WorkSpaceInfoViewModel alloc] init];
    }
    return _infoViewModel;
}

- (void)setTargetController:(UIViewController *)targetController
{
    _targetController = targetController;
    self.infoViewModel.targetController = targetController;
}

@end
