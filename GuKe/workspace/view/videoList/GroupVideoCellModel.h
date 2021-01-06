//
//  GroupVideoCellModel.h
//  GuKe
//
//  Created by saas on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupVideoCellModel : NSObject

@property(nonatomic, copy) NSString *iconUrl;
@property (nonatomic, strong) GroupVideoModel *model;

@end

NS_ASSUME_NONNULL_END
