//
//  ZJNChangePatientBasicInfoModel.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangePatientBasicInfoModel.h"

@implementation ZJNChangePatientBasicInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"birth":@"brith"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    id newValue = [super mj_newValueFromOldValue:oldValue property:property];
    if (newValue && [property.name isEqualToString:@"birth"]) {
        if ([newValue isMemberOfClass:[NSNumber class]]) {
            return [(NSNumber *)newValue stringValue];
        }else if ([newValue isMemberOfClass:[NSString class]]) {
            return newValue;
        }
        return nil;
    }
    return newValue;
}

//- (NSString *)age
//{
//    if (self.birth > 0) {
//        return @(self.birth).stringValue;
//    }
//    return @"";
//}

-(id)initWithMedicalInfoModel:(MedicalRecordsModel *)model{
    self = [super init];
    if (self) {
        self.sessionId = sessionIding;
        self.hospnumId = model.hospid;
        self.patientName = model.patientName;
        self.gender = model.gender;
        self.birth = model.age;
        self.national = model.nation;
        self.linkman = model.linkman;
        self.relation = model.relation;
        self.relationid = model.relationid;
        self.phone = model.phone;
        self.homeAdress = model.homeadress;
        self.provinceId = model.provinceId;
        self.cityId = model.cityId;
        self.districtId = model.districtId;
        self.area = model.area;
        self.idCard = model.idCard;
        
        self.share = model.share;
        self.hospNum = model.hospNum;
        self.inTime = model.intime;
        self.outTime = model.outtime;
        
        self.jbxx = model.jbxx;
        
    }
    return self;
}
@end
