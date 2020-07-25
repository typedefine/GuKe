//
//  ZJNChangeCheckResultModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MedicalRecordsModel.h"
@interface ZJNChangeCheckResultModel : NSObject
/** 唯一标识 */
@property (nonatomic ,strong)NSString * sessionId;
/** 住院主键 */
@property (nonatomic ,strong)NSString * hospnumId;
/** 专科检查 */
@property (nonatomic ,strong)NSString * check;
/** 专科检查单元格高度 */
@property (nonatomic ,assign)CGFloat checkHeight;
/** harris评分 */
@property (nonatomic ,strong)NSString * harris;
/** hss评分 */
@property (nonatomic ,strong)NSString * hss;
/** sf-12评分 */
@property (nonatomic ,strong)NSString * sf;
/** 药物过敏1：有0：无 */
@property (nonatomic ,strong)NSString * allergy;
/** 药物过敏史 */
@property (nonatomic ,strong)NSString * allergyName;
/** 提前计算药物过敏史单元格高度 */
@property (nonatomic ,assign)CGFloat allergyHeight;
// 主诉
@property (nonatomic ,strong)NSString * chief;
//主诉的高度
@property (nonatomic ,assign)CGFloat  chiefHeight;

/** 诊断 */
@property (nonatomic ,strong)NSString * diagnosis;
/** 提前计算诊断单元格高度 */
@property (nonatomic ,assign)CGFloat diagnosisHeight;
/** 心电图1：正常0：异常 */
@property (nonatomic ,strong)NSString * ecg;
/** 心电图检查 */
@property (nonatomic ,strong)NSString * ecgName;
/** 心电图检查单元格高度 */
@property (nonatomic ,assign)CGFloat ecgHeight;
/** 影像学1：正常0：异常 */
@property (nonatomic ,strong)NSString * imaging;
/** 影像学检查 */
@property (nonatomic ,strong)NSString * imagingName;
/** 影像学检查单元格高度 */
@property (nonatomic ,assign)CGFloat imagingHeight;
/** 既往史 */
@property (nonatomic ,strong)NSString * history;
/** 现病史史 */
@property (nonatomic ,strong)NSString * hpi;
/** 现病史单元格高度 */
@property (nonatomic ,assign)CGFloat hpiHeight;
/** 既往史单元格高度 */
@property (nonatomic ,assign)CGFloat historyHeight;
/** 关节 */
@property (nonatomic ,strong)NSArray  * joints;
/** harris评分选项 */
@property (nonatomic ,strong)NSString * harrisuid;
/** hss评分选项 */
@property (nonatomic ,strong)NSString * hssuid;
/** sf评分选项 */
@property (nonatomic ,strong)NSString * sfuid;
/** 患者信息 */
@property (nonatomic ,strong)NSArray * hzxx;
/** 评分的列表 */


/** 检查记录 */
@property (nonatomic ,strong)NSArray  *tzxx;

@property (nonatomic,strong) NSMutableArray * forms;// 评分列表


-(id)initWithMedicalModel:(MedicalRecordsModel *)model;
@end
