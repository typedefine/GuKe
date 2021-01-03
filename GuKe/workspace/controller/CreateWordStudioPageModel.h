//
//  CreateWordStudioPageModel.h
//  GuKe
//
//  Created by yb on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXFInputCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CreateWordStudioPageModel : NSObject

//@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray<ZXFInputCellModel *> *cellModelList;


@end

NS_ASSUME_NONNULL_END
