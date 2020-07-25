//
//  MedicalRecordsModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalRecordsModel : NSObject
@property (nonatomic ,strong)NSString *age;
@property (nonatomic ,strong)NSString *allergy;
@property (nonatomic ,strong)NSString *allergyName;
@property (nonatomic ,strong)NSString *breathe;

@property (nonatomic ,strong)NSString *checks;

@property (nonatomic ,strong)NSString *deptName;
@property (nonatomic ,strong)NSString *chief;

@property (nonatomic ,strong)NSString *diagnosis;
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *ecg;
@property (nonatomic ,strong)NSString *ecgName;
@property (nonatomic ,strong)NSString *gender;
@property (nonatomic ,strong)NSString *harris;
@property (nonatomic ,strong)NSString *harrisuid;
/*现病史*/
@property (nonatomic ,strong)NSString *hpi;
@property (nonatomic ,strong)NSString *history;

@property (nonatomic ,strong)NSString *homeadress;
@property (nonatomic ,strong)NSString *area;
@property (nonatomic ,strong)NSString *provinceId;
@property (nonatomic ,strong)NSString *cityId;
@property (nonatomic ,strong)NSString *districtId;

@property (nonatomic ,strong)NSString *hospNum;
@property (nonatomic ,strong)NSString *hospitalName;
@property (nonatomic ,strong)NSString *hss;
@property (nonatomic ,strong)NSString *hssuid;
@property (nonatomic ,strong)NSString *idCard;
@property (nonatomic ,strong)NSString *imaging;
@property (nonatomic ,strong)NSString *imagingName;
@property (nonatomic ,strong)NSString *intime;
@property (nonatomic ,strong)NSArray  *joints;
@property (nonatomic ,strong)NSString *linkman;
@property (nonatomic ,strong)NSString *nation;
@property (nonatomic ,strong)NSString *outtime;
@property (nonatomic ,strong)NSString *patientName;
@property (nonatomic ,strong)NSString *phone;
@property (nonatomic ,strong)NSString *pressure;
@property (nonatomic ,strong)NSString *pulse;
@property (nonatomic ,strong)NSString *relation;
@property (nonatomic ,strong)NSString *relationid;
@property (nonatomic ,strong)NSString *sf;
@property (nonatomic ,strong)NSString *sfuid;
@property (nonatomic ,strong)NSString *temperature;
@property (nonatomic ,strong)NSArray  *revisit;
@property (nonatomic ,strong)NSArray  *videos;
@property (nonatomic ,strong)NSArray  *share;
@property (nonatomic ,strong)NSArray  *tzxx;
@property (nonatomic ,strong)NSArray  *jbxx;
@property (nonatomic ,strong)NSArray *hzxx;
@property (nonatomic ,strong)NSString *hospid;
@property (nonatomic,strong) NSMutableArray * forms;// 评分列表
@end
