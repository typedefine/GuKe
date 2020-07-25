//
//  WYYSearchYishengModel.h
//  GuKe
//
//  Created by yu on 2018/1/19.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYYSearchYishengModel : NSObject
/*
 birthtime = 38;
 deptName = "\U8fd0\U52a8\U533b\U5b66\U79d1";
 doctorId = 000000005f0108cf015f0a4986440004;
 doctorName = "\U9aa8\U4e09\U5200";
 gender = 1;
 hosptialName = "\U90d1\U5dde\U5e02\U4e2d\U539f\U533b\U9662";
 portrait = "imgs/000000005f48c3a3015f4c71d3fb0453.jpg";
 titleName = "\U526f\U4e3b\U4efb\U533b\U5e08";
 */
@property (nonatomic,strong)NSString *birthtime;
@property (nonatomic,strong)NSString *deptName;
@property (nonatomic,strong)NSString *doctorId;
@property (nonatomic,strong)NSString *doctorName;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *hosptialName;
@property (nonatomic,strong)NSString *portrait;
@property (nonatomic,strong)NSString *titleName;
@property (nonatomic,strong)NSString *specialtyName;
@end
