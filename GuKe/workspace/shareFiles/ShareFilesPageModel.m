//
//  ShareFilesPageModel.m
//  GuKe
//
//  Created by yb on 2021/1/5.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "ShareFilesPageModel.h"

@implementation ShareFilesPageModel

- (instancetype)init
{
    if (self = [super init]) {
        _curPage = 1;
        _pageSize = 10;
    }
    return self;
}

@end
