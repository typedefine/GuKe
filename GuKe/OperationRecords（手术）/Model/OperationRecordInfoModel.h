//
//  OperationRecordInfoModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationRecordInfoModel : NSObject
@property (nonatomic ,strong)NSString *age;
@property (nonatomic ,strong)NSString *deptName;
@property (nonatomic ,strong)NSString *surgeryTypeName; // 手术分类
@property (nonatomic ,strong)NSString *surgeryType;// 手术分类id
@property (nonatomic ,strong)NSString *doctorName;
@property (nonatomic ,strong)NSString *gender;
@property (nonatomic ,strong)NSString *hospNum;
@property (nonatomic ,strong)NSString *hospitalName;
@property (nonatomic ,strong)NSString *patientName;
@property (nonatomic ,strong)NSArray  *surgery;
@end
