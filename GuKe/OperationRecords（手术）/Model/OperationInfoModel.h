//
//  OperationInfoModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationInfoModel : NSObject
@property (nonatomic ,strong)NSString *anesthesiaName;
@property (nonatomic ,strong)NSString *anesthesiaId;
@property (nonatomic ,strong)NSString *approach;
@property (nonatomic ,strong)NSString *firstzs;
@property (nonatomic ,strong)NSString *twozs;
@property (nonatomic ,strong)NSString *surgeryId;
@property (nonatomic ,strong)NSString *brandName;
@property (nonatomic ,strong)NSString *brandId;
@property (nonatomic ,strong)NSArray *brand;//器械品牌的数组
@property (nonatomic ,strong)NSString *doctor;
@property (nonatomic ,strong)NSString *surgeryName;
@property (nonatomic ,strong)NSString *surgeryTime;
@property (nonatomic ,strong)NSArray  *images;
@property (nonatomic ,strong)NSArray  *imagex;
@property (nonatomic ,strong)NSArray  *imaget;
@property (nonatomic ,strong)NSArray  *video;

@property (nonatomic ,strong)NSString *surgeryTypeName; // 手术分类
@property (nonatomic ,strong)NSString *surgeryType;// 手术分类id


@end
