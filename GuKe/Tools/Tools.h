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

+(BOOL)isBlankString:(NSString *)string;
+ (CGSize)sizeOfText:(NSString *)text andMaxSize:(CGSize)size andFont:(UIFont *)font;
+(NSString *)dateFormatterWithDateStringValue:(NSString *)dateStringValue;
+(NSString *)dateFormatterWithMillTimeInterval:(NSString *)timeIntervalString;
+(NSString *)dateFormatterWithTimeInterval:(NSString *)timeIntervalString;
+(NSString *)dateFormatterWithDateStringValue:(NSString *)dateStringValue sourceFormatter:(NSString *)sourceFormatter;
+(NSString *)dateFormatterWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
