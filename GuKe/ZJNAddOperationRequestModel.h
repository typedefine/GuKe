//
//  ZJNAddOperationRequestModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/5.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNAddOperationRequestModel : NSObject

@property (nonatomic ,strong)NSString * sessionid;
@property (nonatomic ,strong)NSString * surgeryTime;//手术时间
@property (nonatomic ,strong)NSString * surgeryType;//手术分类

@property (nonatomic ,strong)NSString * surgeryName;//手术名称
@property (nonatomic ,strong)NSString * attr2;//主刀医生
@property (nonatomic ,strong)NSString * anesthesiaId;//麻醉方式
@property (nonatomic ,strong)NSString * brandId;//品牌id

@property (nonatomic ,strong)NSString * qx;//器械合格证图片
@property (nonatomic ,strong)NSString * hospnumId;//医院ID
@property (nonatomic ,strong)NSString * approach;//手术入路
@property (nonatomic ,strong)NSString * firstzs;//第一助手
@property (nonatomic ,strong)NSString * twozs;//第二助手
@property (nonatomic ,strong)NSString * imagex;//手术X图片
@property (nonatomic ,strong)NSString * imaget;//术后体位图片
@property (nonatomic ,strong)NSString * video;//术后视频


@end
