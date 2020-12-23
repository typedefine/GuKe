//
//  CreateWordStudioPageModel.m
//  GuKe
//
//  Created by yb on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "CreateWordStudioPageModel.h"

@implementation CreateWordStudioPageModel

- (instancetype)init
{
    if (self = [super init]) {
        NSArray *titles = @[@"工作室名称", @"工作室介绍", @"赞助商logo", @"赞助商名称", @"赞助商链接"];
        NSArray *indicates = @[@"请输入工作室名称", @"添加图片", @"请输入工作室介绍", @"添加图片", @"输入链接"];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i=0; i<titles.count; i++) {
            ZXFInputCellModel *cellModel = [[ZXFInputCellModel alloc] init];
            cellModel.title = titles[i];
            cellModel.placeholder = indicates[i];
            [items addObject:cellModel];
        }
        _cellModelList = [items copy];
        
    }
    return self;
}

@end
