//
//  ZJNChangePatientBodyInfoModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedicalRecordsModel.h"
@interface ZJNChangePatientBodyInfoModel : NSObject
/** 唯一标识 */
@property (nonatomic ,strong)NSString * sessionId;
/** 住院主键 */
@property (nonatomic ,strong)NSString * hospnumId;
/** 体温 */
@property (nonatomic ,strong)NSString * temperature;
/** 脉搏 */
@property (nonatomic ,strong)NSString * pulse;
/** 呼吸 */
@property (nonatomic ,strong)NSString * breathe;
/** 血压 */
@property (nonatomic ,strong)NSString * pressure;

/** 生命体征图片*/
@property (nonatomic ,strong)NSArray *tzxx;
/** 患者生命信息图片路径 */
//@property (nonatomic ,strong)NSString *tzxx;
-(id)initWithMedicalInfoModel:(MedicalRecordsModel *)model;
@end
