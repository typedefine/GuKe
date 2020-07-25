//
//  ZJNChangePatientBasicInfoModel.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangePatientBasicInfoModel.h"

@implementation ZJNChangePatientBasicInfoModel
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
