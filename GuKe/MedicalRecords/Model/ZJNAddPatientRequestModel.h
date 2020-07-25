//
//  ZJNAddPatientRequestModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/1.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNAddPatientRequestModel : NSObject
/** sessionid */
@property (nonatomic ,strong)NSString * sessionid;
/** 患者姓名 */
@property (nonatomic ,strong)NSString * patientName;
/** 性别1：男，0：女 */
@property (nonatomic ,strong)NSString * gender;
/** 年龄 */
@property (nonatomic ,strong)NSString * birth;
/** 民族 */
@property (nonatomic ,strong)NSString * national;
/** 身高 */
@property (nonatomic ,strong)NSString * stature;
/** 体重 */
@property (nonatomic ,strong)NSString * weight;
/** 联系人 */
@property (nonatomic ,strong)NSString * linkman;
/** 关系1：配偶2：亲人3：子女4:朋友 */
@property (nonatomic ,strong)NSString * relation;
/** 电话 */
@property (nonatomic ,strong)NSString * phone;
/** 家庭住址详细地址 */
@property (nonatomic ,strong)NSString * homeAdress;
/** 家庭住址省市区 */
@property (nonatomic ,strong)NSString * area;
@property (nonatomic ,strong)NSString * provinceId;//省
@property (nonatomic ,strong)NSString * cityId;//市
@property (nonatomic ,strong)NSString * districtId;//区





/** 身份证 */
@property (nonatomic ,strong)NSString * idCard;
/** 药物过敏1：有0：无 */
@property (nonatomic ,strong)NSString * allergy;
/** 药物过敏史 */
@property (nonatomic ,strong)NSString * allergyName;
/** 体温 */
@property (nonatomic ,strong)NSString * temperature;
/** 脉搏 */
@property (nonatomic ,strong)NSString * pulse;
/** 呼吸 */
@property (nonatomic ,strong)NSString * breathe;
/** 血压 */
@property (nonatomic ,strong)NSString * pressure;
/** 专科检查 */
@property (nonatomic ,strong)NSString * checks;
/** harris评分 */
@property (nonatomic ,strong)NSString * harris;
/** hss评分 */
@property (nonatomic ,strong)NSString * hss;
/** sf评分 */
@property (nonatomic ,strong)NSString * sf;
/** 回访状态1术前2术后3回访 */
@property (nonatomic ,strong)NSString * status;
/** 住院号 */
@property (nonatomic ,strong)NSString * hospNum;
/** 入院时间 */
@property (nonatomic ,strong)NSString * inTime;
/** 出院时间 */
@property (nonatomic ,strong)NSString * outTime;
/** 诊断 */
@property (nonatomic ,strong)NSString * diagnosis;
/** 主诉 */
@property (nonatomic ,strong)NSString * chief;

/** 心电图1：正常0：异常 */
@property (nonatomic ,strong)NSString * ecg;
/** 心电图检查 */
@property (nonatomic ,strong)NSString * ecgName;
/** 影像学1：正常0：异常 */
@property (nonatomic ,strong)NSString * imaging;
/** 影像学检查 */
@property (nonatomic ,strong)NSString * imagingName;
/** 现病史 */
@property (nonatomic ,strong)NSString * hpi;
/** 既往史 */
@property (nonatomic ,strong)NSString * history;
/** 关节 */
@property (nonatomic ,strong)NSString * joints;
/** 化验单 */
@property (nonatomic ,strong)NSString * hy;
/** 体位 */
@property (nonatomic ,strong)NSString * tw;
/** X光 */
@property (nonatomic ,strong)NSString * xg;
/** 患者体征信息 */
@property (nonatomic ,strong)NSString * tzxx;
/** 患者检查信息 */
@property (nonatomic ,strong)NSString * hzxx;
/** 患者基本信息 */
@property (nonatomic ,strong)NSString * jbxx;
/** 患者ID */
@property (nonatomic ,strong)NSString * patientId;
/** 住院ID */
@property (nonatomic ,strong)NSString * hospnumId;
/** 步态视频 */
@property (nonatomic ,strong)NSString * video;
/** 共享的医生 */
@property (nonatomic ,strong)NSString * share;
/** harris评分选项 */
@property (nonatomic ,strong)NSString * harrisuid;
/** hss评分选项 */
@property (nonatomic ,strong)NSString * hssuid;
/** sf评分选项 */
@property (nonatomic ,strong)NSString * sfuid;
/* 评分的数组 */
@property (nonatomic ,strong)NSMutableArray * forms;


@end
