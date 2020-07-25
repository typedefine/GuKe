//
//  ZJNMyDoctorListModel.h
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/16.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJNMyDoctorListModel : NSObject
/** 头像 */
@property (nonatomic ,strong)NSString *portrait;
/** 医生姓名 */
@property (nonatomic ,strong)NSString *doctorName;
/** 性别 0：女 1：男 */
@property (nonatomic ,strong)NSString *gender;
/** 年龄 */
@property (nonatomic ,strong)NSString *birthtime;
/** 医生职位 */
@property (nonatomic ,strong)NSString *titleName;
/** 医院 */
@property (nonatomic ,strong)NSString *hosptialName;
/** 擅长方向 */
@property (nonatomic ,strong)NSString *specialtyName;
/** 科室 */
@property (nonatomic ,strong)NSString *deptName;
/** 个人简介 */
@property (nonatomic ,strong)NSString *content;
/** 医生ID */
@property (nonatomic ,strong)NSString *doctorId;
/** 医生环信ID */
@property (nonatomic ,strong)NSString *doctorhuanId;
/** 是否为好友 0:非好友 1:好友 */
@property (nonatomic ,strong)NSString *isfriend;

@end
