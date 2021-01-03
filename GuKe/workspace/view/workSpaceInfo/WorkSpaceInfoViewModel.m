//
//  WorkSpaceViewModel.m
//  GuKe
//
//  Created by yb on 2020/11/29.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoViewModel.h"
#import "GroupInfoModel.h"
#import "WorkSpaceInfoModel.h"

@implementation WorkSpaceInfoViewModel

- (void)configareWithData:(WorkSpaceInfoModel *)data
{
    self.headerImgUrl = data.headerImgUrl;
    self.textModel.content = data.content;
    self.groups = [data.groups copy];
}


- (ExpandTextCellModel *)textModel
{
    if (!_textModel) {
        _textModel = [[ExpandTextCellModel alloc] init];
    }
    return _textModel;
}


@end
