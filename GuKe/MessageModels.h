//
//  MessageModels.h
//  GuKe
//
//  Created by MYMAc on 2019/4/2.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "title":"测试标题2",
 "des":"测试内容22222222",
 "time":"2019-04-01 04:52:58"
 },
 */
@interface MessageModels : NSObject
@property (strong ,nonatomic) NSString * title;
@property (strong ,nonatomic) NSString * des;
@property (strong ,nonatomic) NSString * time;
@end

NS_ASSUME_NONNULL_END
