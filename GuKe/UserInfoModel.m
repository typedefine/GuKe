//
//  UserInfoModel.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userId": @"userid"};//, @"name":@"nickname"
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"members":[UserInfoModel class]};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"portrait"]) {
        return imgFullUrl(oldValue);
    }
    return [super mj_newValueFromOldValue:oldValue property:property];
}


@end
