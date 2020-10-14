//
//  NSString+containsString.h
//  ECSDKDemo_OC
//
//  Created by admin on 15/11/5.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (containsString)
- (BOOL)myContainsString:(NSString*)other;
+(NSString *)changeNullString:(NSString *)string;
+(void)attributedStringWithHtmlString:(NSString *)string block:(void(^)(NSAttributedString *attString))block;
+(BOOL)IsNullStr:(NSString *)string;

@end
