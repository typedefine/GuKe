//
//  WYYDetailHuanModel.h
//  GuKe
//
//  Created by yu on 2018/1/31.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYYDetailHuanModel : NSObject
/*
hospnumId": 375,//住院ID
"hospNum": "88888",//住院号
 "inTime": "2018-01-10",//治疗时间
 "diagnosis": "左膝关节胫骨平台后缘撕脱性骨折",//诊断
 "doctorName": "王园园",//主治医生
 "hospitalName": "商丘市第一人民医院"//医院
 */
@property (nonatomic,strong)NSString *hospnumId;
@property (nonatomic,strong)NSString *hospNum;
@property (nonatomic,strong)NSString *inTime;
@property (nonatomic,strong)NSString *diagnosis;
@property (nonatomic,strong)NSString *doctorName;
@property (nonatomic,strong)NSString *hospitalName;
@end
