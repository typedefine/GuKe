//
//  Tools.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/12.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "Tools.h"

@implementation Tools


+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (CGSize)sizeOfText:(NSString *)text andMaxSize:(CGSize)size andFont:(UIFont *)font
{
    CGRect f = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return f.size;
}

+(NSString *)dateFormatterWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitDayFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComps = [gregorian components:unitDayFlags fromDate:date toDate:[NSDate date] options:0];
    int days = (int)[dateComps day];
    NSString *timeStr = @"";
    
    
    if (days >= 3) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy - MM - dd";
        timeStr = [dateFormatter stringFromDate:date];
        
    }else if (days == 2){
        timeStr = NSLocalizedString(@"前天", @"时间格式");
    }else if(days == 1){
        timeStr = NSLocalizedString(@"昨天", @"时间格式");//[NSString stringWithFormat:@"%d天前",days];
    }else{
        int hours = (int)[dateComps hour];
        
        if (hours >= 1) {
            timeStr = [NSString stringWithFormat:@"%d %@",hours,NSLocalizedString(@"小时前", @"时间格式")];
            
        }else{
            int minutes = (int)[dateComps minute];
            
            if (minutes >= 1) {
                timeStr = [NSString stringWithFormat:@"%d %@",minutes,NSLocalizedString(@"分钟前", @"时间格式")];
                
            }else{
                timeStr = NSLocalizedString(@"刚刚", @"时间格式");
            }
        }
    }
    return timeStr;
}

+(NSString *)dateFormatterWithDateStringValue:(NSString *)dateStringValue
{
    if (!dateStringValue.isValidStringValue) return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd dd:mm";
    NSDate *date = [dateFormatter dateFromString:dateStringValue];
    return [self dateFormatterWithDate:date];
}

+(NSString *)dateFormatterWithDateStringValue:(NSString *)dateStringValue sourceFormatter:(NSString *)sourceFormatter
{
    if (!dateStringValue.isValidStringValue) return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = sourceFormatter;
    NSDate *date = [dateFormatter dateFromString:dateStringValue];
    return [self dateFormatterWithDate:date];
}

+(NSString *)dateFormatterWithMillTimeInterval:(NSString *)timeIntervalString
{
    if (!timeIntervalString.isValidStringValue) return @"";
    NSTimeInterval timeInterval = [timeIntervalString doubleValue]/1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self dateFormatterWithDate:date];
}

+(NSString *)dateFormatterWithTimeInterval:(NSString *)timeIntervalString
{
    if (!timeIntervalString.isValidStringValue) return @"";
    NSTimeInterval timeInterval = [timeIntervalString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self dateFormatterWithDate:date];
}

+(NSString *)dateFormatInTheFutureWithTimeInterval:(NSString *)timeIntervalString
{
    if (!timeIntervalString.isValidStringValue) return @"";
    NSTimeInterval timeInterval = [timeIntervalString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd dd:mm";
    return [dateFormatter stringFromDate:date];
}


@end
