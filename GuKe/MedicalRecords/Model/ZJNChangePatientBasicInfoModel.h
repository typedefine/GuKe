//
//  ZJNChangePatientBasicInfoModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedicalRecordsModel.h"
#import "GJObject.h"
@interface ZJNChangePatientBasicInfoModel : GJObject
/** 唯一标识 */
@property (nonatomic ,strong)NSString * sessionId;
/** 住院主键 */
@property (nonatomic ,strong)NSString * hospnumId;
/** 患者姓名 */
@property (nonatomic ,strong)NSString * patientName;
/** 性别1：男，0：女 */
@property (nonatomic ,strong)NSString * gender;
/** 年龄 */
@property (nonatomic ,strong)NSString * birth;
/** 民族 */
@property (nonatomic ,strong)NSString * national;
/** 联系人 */
@property (nonatomic ,strong)NSString * linkman;
/** 关系 */
@property (nonatomic ,strong)NSString * relation;
/** 关系id */ 
@property (nonatomic ,strong)NSString *relationid;

/** 电话 */
@property (nonatomic ,strong)NSString * phone;
/** 家庭住址 */
@property (nonatomic ,strong)NSString * homeAdress;
/** 家庭住址  省市区id  */
@property (nonatomic ,strong)NSString * area;
@property (nonatomic ,strong)NSString * provinceId;
@property (nonatomic ,strong)NSString * cityId;
@property (nonatomic ,strong)NSString * districtId;
/** 身份证 */
@property (nonatomic ,strong)NSString * idCard;
/** 共享的医生英文逗号隔开 */
@property (nonatomic ,strong)NSArray  * share;
/** 住院号 */
@property (nonatomic ,strong)NSString * hospNum;
/** 入院时间 */
@property (nonatomic ,strong)NSString * inTime;
/** 出院时间 */
@property (nonatomic ,strong)NSString * outTime;
/** 患者基本信息图片路径 */
@property (nonatomic ,strong)NSArray * jbxx;

/** 身高 */
@property (nonatomic, assign) NSInteger stature;

-(id)initWithMedicalInfoModel:(MedicalRecordsModel *)model;
@end
