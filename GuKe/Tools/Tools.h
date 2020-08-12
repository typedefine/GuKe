//
//  Tools.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/12.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

+(NSString *)dateFormatterWithDateStringValue:(NSString *)dateStringValue;
+(NSString *)dateFormatterWithTimeInterval:(NSString *)timeIntervalString;
+(NSString *)dateFormatterWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
