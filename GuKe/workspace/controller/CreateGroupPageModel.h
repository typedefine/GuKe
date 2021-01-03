//
//  CreateGroupPageModel.h
//  GuKe
//
//  Created by yb on 2021/1/2.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXFInputCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateGroupPageModel : NSObject

@property(nonatomic, strong) NSArray<ZXFInputCellModel *> *cellModelList;

@end

NS_ASSUME_NONNULL_END
