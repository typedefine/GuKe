//
//  WorkSpaceViewModel.h
//  GuKe
//
//  Created by yb on 2020/11/29.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpandTextCellModel.h"
@class GroupInfoModel, WorkSpaceInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface WorkSpaceInfoViewModel : NSObject

//@property (nonatomic, copy) NSString *sessionid;

@property (nonatomic, copy) NSString *headerImgUrl;

@property (nonatomic, strong) ExpandTextCellModel *textModel;

@property (nonatomic, strong) NSArray<GroupInfoModel *> *groups;


- (void)configareWithData:(WorkSpaceInfoModel *)data;

@end

NS_ASSUME_NONNULL_END
