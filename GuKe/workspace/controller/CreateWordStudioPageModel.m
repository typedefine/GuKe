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
        NSArray *titles = @[@"工作室名称", @"工作室图片", @"工作室介绍", @"赞助商logo", @"赞助商名称", @"赞助商链接"];
        NSArray *indicates = @[@"请输入工作室名称", @"添加图片", @"请输入工作室介绍", @"添加图片", @"输入名称", @"输入链接"];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i=0; i<titles.count; i++) {
            ZXFInputCellModel *cellModel = [[ZXFInputCellModel alloc] init];
            cellModel.title = titles[i];
            cellModel.placeholder = indicates[i];
            [items addObject:cellModel];
        }
        _cellModelList = [items copy];
        _cellModelList[3].height = _cellModelList[1].height = IPHONE_X_SCALE(120);
        _cellModelList[3].cellType = _cellModelList[1].cellType = ZXFInputCellTypeImagePick;
        _cellModelList[2].height = IPHONE_X_SCALE(160);
        _cellModelList[2].cellType = ZXFInputCellTypeTextView;
    }
    return self;
}

@end
