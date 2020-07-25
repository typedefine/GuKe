//
//  ZJNChangeOperationRequestModel.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationInfoModel.h"
@interface ZJNChangeOperationRequestModel : NSObject
@property (nonatomic ,strong)NSString * sessionId;
@property (nonatomic ,strong)NSString * surgeryId;
@property (nonatomic ,strong)NSString * surgeryTime;
@property (nonatomic ,strong)NSString * surgeryName;
@property (nonatomic ,strong)NSString * attr2;
@property (nonatomic ,strong)NSString * anesthesiaId;
@property (nonatomic ,strong)NSString * anesthesiaName;
@property (nonatomic ,strong)NSString * approach;
@property (nonatomic ,strong)NSString * firstzs;
@property (nonatomic ,strong)NSString * twozs;
@property (nonatomic ,strong)NSMutableArray * qx;
@property (nonatomic ,strong)NSMutableArray * imagex;
@property (nonatomic ,strong)NSMutableArray * imaget;
@property (nonatomic ,strong)NSMutableArray * video;
@property (nonatomic ,strong)NSString * brandName;// 品牌的名字
@property (nonatomic ,strong)NSString* brandId;// 品牌的id
@property (nonatomic ,strong)NSArray * brand;// 品牌的数组
@property (nonatomic ,strong)NSString * surgeryType;// 手术分类id
@property (nonatomic ,strong)NSString * surgeryTypeName;//手术分类名字


-(id)initWithOperationModel:(OperationInfoModel *)model;
@end
