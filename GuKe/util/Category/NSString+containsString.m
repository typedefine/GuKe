//
//  NSString+containsString.m
//  ECSDKDemo_OC
//
//  Created by admin on 15/11/5.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import "NSString+containsString.h"

@implementation NSString (containsString)

- (BOOL)myContainsString:(NSString*)other {
    
    if ([[UIDevice currentDevice].systemVersion integerValue] >7) {
        return [self containsString:other];
    }
    NSRange range = [self rangeOfString:other];
    return (range.location == NSNotFound?NO:YES);
}
+(NSString *)changeNullString:(NSString *)string{
    if (string == nil || [string isKindOfClass:[NSNull class]] ||[string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || string.length == 0) {
        string = @"";
    }
    return string;
}
+(BOOL)IsNullStr:(NSString *)string{
    
    if (string == nil || [string isKindOfClass:[NSNull class]] ||[string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || string.length == 0) {
        return YES ;
    }
    return NO ;
 }
+(void)attributedStringWithHtmlString:(NSString *)string block:(void(^)(NSAttributedString *attString))block{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(attString);
        });
    });
}
@end
