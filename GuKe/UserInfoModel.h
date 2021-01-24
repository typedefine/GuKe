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
@property (nonatomic, copy) NSString *userid;
@property (nonatomic ,copy) NSString *portrait;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, copy) NSString *roleName;//通讯录标签

//身份名称类型
//工作室1:管理员 2：会长/秘书长
//讨论组1：组长  2：核心成员
@property (nonatomic, assign) NSInteger roleType;//通讯录标签类型 0 普通成员  1 管理员（换色标签）  2 身份标签（绿色标签）

@property (nonatomic, assign) NSInteger isFriend;//0 不是好友  1是好友

@end
