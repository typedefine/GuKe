//
//  WorkGroupListViewModel.h
//  GuKe
//
//  Created by yb on 2020/12/4.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupUnionInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupListViewModel : NSObject

@property (nonatomic, strong) NSArray<GroupUnionInfoModel *> *groupList;

- (void)configareWithData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
