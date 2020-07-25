//
//  ZJNChangePatientBodyInfoModel.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangePatientBodyInfoModel.h"

@implementation ZJNChangePatientBodyInfoModel
-(id)initWithMedicalInfoModel:(MedicalRecordsModel *)model{
    self = [super init];
    if (self) {
        self.sessionId = sessionIding;
        self.hospnumId = model.hospid;
        self.temperature = model.temperature;
        self.pulse = model.pulse;
        self.breathe = model.breathe;
        self.pressure = model.pressure;
        self.tzxx = model.tzxx;
    }
    return self;
}
@end
