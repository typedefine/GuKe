//
//  moduleDate.m
//  GuKe
//
//  Created by MYMAc on 2019/2/26.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "moduleDate.h"

@implementation moduleDate

+(instancetype)ShareModuleDate{
    static moduleDate * model ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model =[[moduleDate alloc]init];

    });
    
//    比如更换账号的时候，上传老账号的数据，重新计算新数据
    if (model.OpenAPPDate == nil) {
        model.OpenAPPDate = [NSDate date];
        //        set方法内部为累加，赋值 相当于初始化为0 ;
        model.TrainingLength = - model.TrainingLength;
        model.MeetingLength = - model.MeetingLength;
        model.DouctFriendsLength = -model.DouctFriendsLength;
        model.ShipinLength = -model.ShipinLength;
        model.MessageLength = -model.MessageLength;
        model.IformationLength = -model.IformationLength;
        model.MymeetingLength = -model.MymeetingLength;
    }
    return model;
}
//提交数据
-(void)CommitData{
    NSDate * NowDate =[NSDate date];
    NSTimeInterval time = [NowDate timeIntervalSinceDate:self.OpenAPPDate]; //开机运行时间
    //   结束时间  NowDate  就是当前时间；
 
    NSLog(@"开始时间：%@\n 结束时间：%@\n 运行时长：%ld\n 专项培训时长：%ld\n 热门会议时长:%ld\n 医生好友时长:%ld\n 视频时长:%ld\n 消息时长:%ld\n 资讯时长:%ld\n 我组织的会议时长:%ld\n",self.OpenAPPDate,NowDate,(long)time,(long)self.TrainingLength,(long)self.MeetingLength,(long)self.DouctFriendsLength,self.ShipinLength,self.MessageLength,self.IformationLength,self.MymeetingLength);
    
    
    
    NSString * UidStr =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
    if ([NSString IsNullStr:UidStr]) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,PubStatisticalSave];
    NSArray *keysArray = @[@"userId",@"totalTime",@"startTime",@"endTime",@"trainStatistical",@"meetingStatistical",@"friendStatistical",@"videoStatistical",@"messageStatistical",@"infoStatistical",@"organizationStatistical"];
    NSArray *valueArray = @[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"],[NSString stringWithFormat:@"%d",(NSInteger)time],self.OpenAPPDate,NowDate,[NSString stringWithFormat:@"专项培训,%ld",(long)self.TrainingLength],[NSString stringWithFormat:@"热门会议,%ld",(long)self.MeetingLength],[NSString stringWithFormat:@"医生好友,%d",(long)self.DouctFriendsLength],[NSString stringWithFormat:@"视频,%d",(long)self.ShipinLength],[NSString stringWithFormat:@"消息,%d",(long)self.MessageLength],[NSString stringWithFormat:@"资讯,%d",(long)self.IformationLength],[NSString stringWithFormat:@"我组织的会议,%d",(long)self.MymeetingLength]];
 
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
  
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"保存情况 成功%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            
           
            
        }
    } failure:^(NSError *error) {
        NSLog(@"保存失败%@",error);
    }];


//    不管提交成功或者失败  删除本次数据
    [self removeDate];

}
-(void)removeDate{
    
    self.OpenAPPDate = nil;
    
    
}
//开机时长
-(void)setOpenAPPDate:(NSDate *)OpenAPPDate{
     _OpenAPPDate  = OpenAPPDate;
 }
//专项训练
-(void)setTrainingLength:(NSInteger)TrainingLength{
  
    _TrainingLength +=TrainingLength;
}
//热门会议
-(void)setMeetingLength:(NSInteger)MeetingLength{
    
    _MeetingLength += MeetingLength;
}
//医生好友
-(void)setDouctFriendsLength:(NSInteger)DouctFriendsLength{
    
    _DouctFriendsLength += DouctFriendsLength;
}

//视频
-(void)setShipinLength:(NSInteger)ShipinLength{
   
    _ShipinLength +=ShipinLength;
}
//消息
-(void)setMessageLength:(NSInteger)MessageLength{
    
    _MessageLength += MessageLength;
}
//资讯
-(void)setIformationLength:(NSInteger)IformationLength{
    
    _IformationLength +=IformationLength;
}
//我组织的会议
-(void)setMymeetingLength:(NSInteger)MymeetingLength{
     _MymeetingLength += MymeetingLength;
    
}









@end
