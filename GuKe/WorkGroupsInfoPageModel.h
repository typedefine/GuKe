//
//  WorkGroupsInfoPageModel.h
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkSpaceInfoCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupsInfoPageModel : NSObject

@property (nonatomic, copy) NSString *workSpacetitle;
@property (nonatomic, strong) WorkSpaceInfoCellModel *workSpaceModel;

@property (nonatomic, copy) NSString *workGrouptitle;
@property (nonatomic, copy) NSString *addGroupActionTitle;

@property (nonatomic, strong) NSArray *workGroups;

@end

NS_ASSUME_NONNULL_END
