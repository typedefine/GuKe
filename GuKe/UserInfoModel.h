//
//  UserInfoModel.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "GJObject.h"

@interface UserInfoModel : GJObject
@property (nonatomic ,strong)NSString * birth;
@property (nonatomic ,strong)NSString * content;
@property (nonatomic ,strong)NSString * deptId;
@property (nonatomic ,strong)NSString * deptName;
@property (nonatomic, copy) NSString *doctorId;
@property (nonatomic ,strong)NSString * doctorName;
@property (nonatomic ,strong)NSString * email;
@property (nonatomic ,strong)NSString * gender;
@property (nonatomic ,strong)NSString * hospitalId;
@property (nonatomic ,strong)NSString * hospitalName;
@property (nonatomic ,strong)NSString * num;
@property (nonatomic ,strong)NSString * phone;

@property (nonatomic ,strong)NSString * status;
@property (nonatomic ,strong)NSString * titleId;
@property (nonatomic ,strong)NSString * titleName;
@property (nonatomic ,strong)NSArray  * specialty;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic ,copy) NSString *portrait;
//@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *pwd;

@end
