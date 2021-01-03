//
//  WorkGroupListViewModel.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupInfoModel.h"
@class WorkSpaceInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupListViewModel : NSObject

@property (nonatomic, strong) NSArray<GroupInfoModel *> *groupList;

- (void)configareWithData:(WorkSpaceInfoModel *)data;

@end

NS_ASSUME_NONNULL_END
