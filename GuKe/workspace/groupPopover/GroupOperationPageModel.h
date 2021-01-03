//
//  GroupOperationPageModel.h
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupOperationItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupOperationPageModel : NSObject

@property (nonatomic, strong) NSArray<GroupOperationItemModel *> *items;

@end

NS_ASSUME_NONNULL_END
