//
//  CreateGroupPageModel.m
//  GuKe
//
//  Created by yb on 2021/1/2.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "CreateGroupPageModel.h"

@implementation CreateGroupPageModel

- (instancetype)init
{
    if (self = [super init]) {
        NSArray *titles = @[@"工作组名称", @"工作组图片", @"工作组介绍"];
        NSArray *indicates = @[@"请输入工作组名称", @"添加图片", @"请输入工作组介绍"];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
        for (int i=0; i<titles.count; i++) {
            ZXFInputCellModel *cellModel = [[ZXFInputCellModel alloc] init];
            cellModel.title = titles[i];
            cellModel.placeholder = indicates[i];
            [items addObject:cellModel];
        }
        _cellModelList = [items copy];
        _cellModelList[1].height = IPHONE_X_SCALE(120);
        _cellModelList[1].cellType = ZXFInputCellTypeImagePick;
        _cellModelList[2].height = IPHONE_X_SCALE(160);
        _cellModelList[2].cellType = ZXFInputCellTypeTextView;
    }
    return self;
}

@end
