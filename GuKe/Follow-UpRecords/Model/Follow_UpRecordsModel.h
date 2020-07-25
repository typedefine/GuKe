//
//  Follow-UpRecordsModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Follow_UpRecordsModel : NSObject
@property (nonatomic ,strong)NSString *age;
@property (nonatomic ,strong)NSString *gender;
@property (nonatomic ,strong)NSString *hospNum;
@property (nonatomic ,strong)NSString *linkman;
@property (nonatomic ,strong)NSString *national;
@property (nonatomic ,strong)NSString *patientName;
@property (nonatomic ,strong)NSString *phone;
@property (nonatomic ,strong)NSString *relation;
@property (nonatomic ,strong)NSArray  *revisit;

-(id)initModelWithDictionart:(NSDictionary *)dic;
@end
