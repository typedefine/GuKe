//
//  WorkSpaceViewModel.h
//  GuKe
//
//  Created by yb on 2020/11/29.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandTextCellModel.h"
@class WorkGroupItemCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceInfoViewModel : NSObject

@property (nonatomic, strong) UIViewController *targetController;

//@property (nonatomic, copy) NSString *sessionid;

@property (nonatomic, copy) NSString *headerImgUrl;

@property (nonatomic, strong) ExpandTextCellModel *textModel;

@property (nonatomic, strong) NSArray<WorkGroupItemCellModel *> *groups;


- (void)configareWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
