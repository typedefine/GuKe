//
//  GroupInfoModel.m
//  GuKe
//
//  Created by yb on 2020/12/6.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupInfoModel.h"
#import "UserInfoModel.h"
@implementation GroupInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"joinStatus":@"isJoined"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"chatroom" : [GroupInfoModel class], @"members":[UserInfoModel class]};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"groupPortrait"] || [property.name isEqualToString:@"sponsorLogo"]) {
        return imgFullUrl(oldValue);
    }
    return [super mj_newValueFromOldValue:oldValue property:property];
}


- (NSString *)countTitle
{
    if (!_countTitle) {
        if (self.members == 0) {
            _countTitle = @"";
        }else if(self.count > 99){
            _countTitle = @"99+";
        }else{
            _countTitle = @(self.count).stringValue;
        }
    }
    return _countTitle;
}

//- (BOOL)isManager
//{
//    return self.isOwner == 1;
////    NSString * selfId = [GuKeCache shareCache].user.userId;
////    for (UserInfoModel *u in self.members) {
////        if ([u.userId isEqualToString:selfId]) {
////            if (u.roleType == 1) {
////                return YES;
////            }
////            return NO;
////        }
////    }
////    return NO;
//}

@end
