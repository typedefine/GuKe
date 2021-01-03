//
//  WorkGroupsInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoPageModel.h"


@implementation WorkSpaceInfoPageModel

- (instancetype)init
{
    if (self = [super init]) {
        _model = [[WorkSpaceInfoModel alloc] init];
//        self.workSpacetitle = @"骨先生工作站";
//        self.workGrouptitle = @"工作室";
//        self.addGroupActionTitle = @"申请开通工作室";
    }
    return self;
}


- (void)configareWithData:(NSDictionary *)data
{
    self.model = [WorkSpaceInfoModel mj_objectWithKeyValues:data];
}

//- (WorkSpaceInfoViewModel *)infoViewModel
//{
//    if (!_infoViewModel) {
//        _infoViewModel = [[WorkSpaceInfoViewModel alloc] init];
//    }
//    return _infoViewModel;
//}
//
//
//- (WorkGroupListViewModel *)listViewModel
//{
//    if (!_listViewModel) {
//        _listViewModel = [[WorkGroupListViewModel alloc] init];
//    }
//    return _listViewModel;
//}

//- (void)setTargetController:(UIViewController *)targetController
//{
//    _targetController = targetController;
//    self.infoViewModel.targetController = targetController;
//    self.listViewModel.targetController = targetController;
//}

@end
