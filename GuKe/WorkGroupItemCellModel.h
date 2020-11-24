//
//  WorkGroupItemCellModel.h
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkGroupItemCellModel : NSObject

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *title;

//@property (nonatomic) SEL action;
//@property (nonatomic) id target;

@end

NS_ASSUME_NONNULL_END
