//
//  ZJNChangeFollowUpRequestModel.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/9.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangeFollowUpRequestModel.h"

@implementation ZJNChangeFollowUpRequestModel
-(id)initWithModel:(Follow_UpRecordsRevisitModel *)model{
    self = [super init];
    if (self) {
        self.sessionId = sessionIding;
        self.checkId = model.uid;
        self.createTime = model.createTime;
        self.visitTime = model.visitTime;
        
        self.temperature = model.temperature;
        self.pulse = model.pulse;
        self.breathe = model.breathe;
        self.pressure = model.pressure;
        self.checks = model.checks;
        self.harris = model.harris;
        self.harrisuid = model.harrisuid;
        self.hss = model.hss;
        self.hssuid = model.hssuid;
        self.sf = model.sf;
        self.sfuid = model.sfuid;
        self.PingfenArray = model.PingfenArray;
        NSMutableArray *twArr = [NSMutableArray array];
        for (NSDictionary *dic in model.twimages) {
            [twArr addObject:dic[@"path"]];
        }
        
        NSMutableArray *hyArr = [NSMutableArray array];
        for (NSDictionary *dic in model.hyimages) {
            [hyArr addObject:dic[@"path"]];
        }
        
        NSMutableArray *xgArr = [NSMutableArray array];
        for (NSDictionary *dic in model.ximages) {
            [xgArr addObject:dic[@"path"]];
        }
        
        NSMutableArray *videoArr = [NSMutableArray array];
        for (NSDictionary *dic in model.videos) {
            [videoArr addObject:dic[@"path"]];
        }
        
        self.tw = [twArr componentsJoinedByString:@","];
        self.hy = [hyArr componentsJoinedByString:@","];
        self.xg = [xgArr componentsJoinedByString:@","];
        self.video = [videoArr componentsJoinedByString:@","];
    }
    return self;

}
@end
