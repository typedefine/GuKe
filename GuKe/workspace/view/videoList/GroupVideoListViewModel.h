//
//  GroupVideoListViewModel.h
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupVideoCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupVideoListViewModel : NSObject

@property(nonatomic, strong) NSArray<GroupVideoCellModel *> *items;

- (void)configWithData:(NSArray<NSDictionary *> *)dataList;

@end

NS_ASSUME_NONNULL_END
