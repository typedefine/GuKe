//
//  WYYFMDBManager.m
//  GuKe
//
//  Created by yu on 2018/1/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYFMDBManager.h"

@implementation WYYFMDBManager{
    FMDatabase *_db;
}

+ (WYYFMDBManager *)shareWYYManager{
    static WYYFMDBManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WYYFMDBManager alloc]init];
    });
    return manager;
}

-(id)init{
    self = [super init];
    if (self) {
        NSString *path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:@"/Documents/GuKe.db"];
        _db = [[FMDatabase alloc]initWithPath:path];
        BOOL ret = [_db open];
        if (ret) {
            NSLog(@"打开数据库成功");
            [self creatUserInfoTable];
        }
    }
    return self;
}

#pragma mark--用户信息

/**
 创建用户信息表单
 */
-(void)creatUserInfoTable{
    
    NSString *sqlStr = @"create table if not exists UserInfo(patient,name,portrait,userId,doctorId,groupid,groupname,age,gender)";
    BOOL ret = [_db executeUpdate:sqlStr];
    if (ret) {
        NSLog(@"创建用户数据表成功");
    }else{
        NSLog(@"创建用户数据表失败");
    }
}
-(void)addFriendListModel:(WYYYIshengFriend *)model{
    BOOL isExist = [self isExistInfoTable:model.userId];
    BOOL isGroup  =[self isGroupInfoTable:model.groupid];
    
    if (!isExist && !isGroup) {
        NSString *string = @"insert into UserInfo (patient,name,portrait,userId,doctorId,groupid,groupname,age,gender) values(?,?,?,?,?,?,?,?,?)";
        BOOL ret = [_db executeUpdate:string,model.patient,model.name,model.portrait,model.userId,model.doctorId,model.groupid,model.groupname,model.age,model.gender];
        if (ret) {
            NSLog(@"插入成功");
        }else
        {
            NSLog(@"插入失败");
        }
    }else{
        [self changeFriendListModel:model];
    }
}
-(void)changeFriendListModel:(WYYYIshengFriend *)model{
    
    NSString *sqlStr = @"update UserInfo set patient=?,name=?,portrait=?,doctorId=?,groupid=?,groupname=?,age=?,gender=? where userId = ?";
    BOOL ret = [_db executeUpdate:sqlStr,model.patient,model.name
                ,model.portrait,model.doctorId,model.groupid,model.groupname,model.age,model.gender,model.userId];
 
    if (ret) {
        NSLog(@"修改用户信息表成功");
    }else{
        NSLog(@"修改用户信息表失败");
    }
}

-(void)deleteFriendListModel:(WYYYIshengFriend *)model{
    NSString *sqlStr = @"delete from UserInfo where userId=?";
    BOOL ret = [_db executeUpdate:sqlStr,model.userId];
    if (ret) {
        NSLog(@"删除用户信息成功");
    }else{
        NSLog(@"删除用户信息失败");
    }
}
- (WYYYIshengFriend *)getFriendInfoModel:(NSString *)userId{
    WYYYIshengFriend *model = [[WYYYIshengFriend alloc]init];
    NSString *sqlStr = @"select *from UserInfo where userId=?";
    FMResultSet *set = [_db executeQuery:sqlStr,userId];
    if ([set next]) {
        model.patient    = [set stringForColumn:@"patient"];
        model.name     = [set stringForColumn:@"name"];
         model.portrait     = [set stringForColumn:@"portrait"];
        model.userId        = [set stringForColumn:@"userId"];
        model.doctorId          = [set stringForColumn:@"doctorId"];
        
        model.age = [set stringForColumn:@"age"];
        model.gender = [set stringForColumn:@"gender"];
        
    }
    
    if(!model){
        [self getUserInfoiWithUserId:userId];
    }
    return model;
}
- (WYYYIshengFriend *)getGroupInfoModel:(NSString *)groupid{
    WYYYIshengFriend *model = [[WYYYIshengFriend alloc]init];
    NSString *sqlStr = @"select *from UserInfo where groupid=?";
    FMResultSet *set = [_db executeQuery:sqlStr,groupid];
    if ([set next]) {
        model.groupname   = [set stringForColumn:@"groupname"];
        model.portrait    = [set stringForColumn:@"portrait"];
        model.groupid = [set stringForColumn:@"groupid"];
    }
    return model;
}
- (BOOL)isExistInfoTable:(NSString *)userId{
    
    NSString *sqlStr = @"select *from UserInfo where userId=?";
    FMResultSet *set = [_db executeQuery:sqlStr,userId];
    
    if([set next]){
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isGroupInfoTable:(NSString *)groupid{
    NSString *sqlStr = @"select *from UserInfo where groupid=?";
    FMResultSet *set = [_db executeQuery:sqlStr,groupid];
    
    if([set next]){
        return YES;
    }else{
        return NO;
    }
}

//数据库表里面没有这个好友信息的话请求数据插入表中
#pragma mark  获取在线客服信息
- (void)getUserInfoiWithUserId:(NSString * )User_id{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,goodfriendlookdoctor];
    NSArray *keysArray = @[@"sessionId",@"userid"];
    NSArray *valueArray = @[sessionIding,User_id];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"医生详情%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            
            WYYYIshengFriend *model = [[WYYYIshengFriend alloc]init];
            model.name  = data[@"data"][@"titleName"];
            model.userId  = data[@"data"][@"uid"];
            model.portrait  = data[@"data"][@"portrait"];
            [self addFriendListModel:model];
            
            
        }
    } failure:^(NSError *error) {
        NSLog(@"医生详情%@",error);
    }];
}



@end
