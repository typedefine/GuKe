//
//  PatientInfoManageModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/12.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientInfoManageModel.h"
#import "PatientBookInfoStateModel.h"

@implementation PatientInfoManageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bookInfoStateList" : @"reply"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"bookInfoStateList" : [PatientBookInfoStateModel class]};
}

@end
