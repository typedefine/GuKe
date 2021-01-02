//
//  WorkGroupInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/11/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkStudioInfoPageModel.h"

@implementation WorkStudioInfoPageModel

- (instancetype)init
{
    if (self = [super init]) {
        _name = @"";
        _logoUrl = @"";
        _members = @[];
    }
    return self;
}

- (void)configareWithData:(NSDictionary *)data
{
    _model = [GroupInfoModel mj_objectWithKeyValues:data];
    self.name = self.model.groupName;
    self.logoUrl = self.model.groupPortrait;//imgFullUrl(self.model.groupPortrait);
    self.supporterUrl = self.model.sponsorUrl;
    self.supporterLogo = self.model.sponsorLogo;//imgFullUrl(self.model.sponsorLogo);
    self.infoCellModel.content = self.model.groupDesc;
    self.members = self.model.members;
}

- (ExpandTextCellModel *)infoCellModel
{
    if (!_infoCellModel) {
        _infoCellModel = [[ExpandTextCellModel alloc] init];
    }
    return _infoCellModel;
}

- (GroupInfoModel *)model
{
    if (!_model) {
        _model = [[GroupInfoModel alloc] init];
    }
    return _model;
}

@end
