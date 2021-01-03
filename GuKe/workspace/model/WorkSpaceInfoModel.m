//
//  WorkSpaceInfoModel.m
//  GuKe
//
//  Created by yb on 2021/1/2.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoModel.h"
#import "GroupInfoModel.h"

@implementation WorkSpaceInfoModel

- (instancetype)init
{
    if (self = [super init]) {
        _groups = @[];
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"groups":@"data", @"headerImgUrl":@"gxsPic", @"content":@"gxsIntro"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"groups" : [GroupInfoModel class]};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"headerImgUrl"]) {
        return imgFullUrl(oldValue);
    }
    return [super mj_newValueFromOldValue:oldValue property:property];
}

@end
