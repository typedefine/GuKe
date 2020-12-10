//
//  GroupInfoModel.m
//  GuKe
//
//  Created by yb on 2020/12/6.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupInfoModel.h"

@implementation GroupInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

- (NSString *)countTitle
{
    if (!_countTitle) {
        if (self.count == 0) {
            _countTitle = @"";
        }else if(self.count > 99){
            _countTitle = @"99+";
        }else{
            _countTitle = @(self.count).stringValue;
        }
    }
    return _countTitle;
}

@end
