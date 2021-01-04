//
//  GroupOperationItemModel.h
//  GuKe
//
//  Created by yb on 2021/1/4.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, GroupOperationType){
    GroupOperationType_Introduce=0,
    GroupOperationType_Create=1,
    GroupOperationType_memberManage=2,
    GroupOperationType_Transfer=3
};
NS_ASSUME_NONNULL_BEGIN

@interface GroupOperationItemModel : NSObject

@property (nonatomic, assign) GroupOperationType type;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
