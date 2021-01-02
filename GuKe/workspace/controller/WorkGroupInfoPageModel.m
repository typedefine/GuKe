//
//  WorkGroupInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/12/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupInfoPageModel.h"

@implementation WorkGroupInfoPageModel

- (void)configareWithData:(id)data
{
    self.model = [GroupInfoModel mj_objectWithKeyValues:data];
    self.name = self.model.groupName;
    self.des = self.model.groupDesc;
    self.members = self.model.members;
}

@end
