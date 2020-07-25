//
//  Follow-UpRecordsModel.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "Follow_UpRecordsModel.h"
#import "Follow_UpRecordsRevisitModel.h"
#import "PingfenModel.h"
@implementation Follow_UpRecordsModel
-(id)initModelWithDictionart:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        self.age = [NSString stringWithFormat:@"%@",dic[@"age"]];
        self.gender = dic[@"gender"];
        self.hospNum = dic[@"hospNum"];
        self.linkman = dic[@"linkman"];
        self.patientName = dic[@"patientName"];
        self.phone = dic[@"phone"];
        self.relation = dic[@"relation"];
        self.national = dic[@"national"];
        NSArray *array = dic[@"revisit"];
        NSMutableArray *modelArr = [NSMutableArray array];
        for (int i = 0; i <array.count; i ++) {
            NSDictionary *dic = array[i];
            Follow_UpRecordsRevisitModel *model = [Follow_UpRecordsRevisitModel yy_modelWithDictionary:dic];
            model.PingfenArray =[[NSMutableArray alloc]init];
            model.selectedButton = @"hy";
            for (NSDictionary * formsdic in dic[@"forms"]) {
                PingfenModel * pingfenmoel = [PingfenModel yy_modelWithJSON:formsdic];
                [model.PingfenArray addObject:pingfenmoel];
                 
            }
            [modelArr addObject:model];
        }
        self.revisit = modelArr;
    }
    return self;    
}
@end


