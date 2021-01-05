//
//  GroupAddressbookPageModel.h
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupAddressbookPageModel : NSObject

@property (nonatomic, strong) NSArray<UserInfoModel *> *members;

@end

NS_ASSUME_NONNULL_END
