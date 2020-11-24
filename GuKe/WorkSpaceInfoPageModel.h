//
//  WorkGroupsInfoPageModel.h
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkSpaceInfoCellModel.h"
@class WorkGroupItemCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceInfoPageModel : NSObject

//@property (nonatomic, copy) NSString *workSpacetitle;
@property (nonatomic, strong) WorkSpaceInfoCellModel *workSpaceModel;

//@property (nonatomic, copy) NSString *workGrouptitle;
//@property (nonatomic, copy) NSString *addGroupActionTitle;

@property (nonatomic, strong) NSArray<WorkGroupItemCellModel *> *workGroups;

- (void)configareWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
