//
//  ZJNChangeCheckResultModel.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangeCheckResultModel.h"

@implementation ZJNChangeCheckResultModel
-(id)initWithMedicalModel:(MedicalRecordsModel *)model{
    self = [super init];
    if (self) {
        self.sessionId = sessionIding;
        self.hospnumId = model.hospid;
        self.tzxx = model.tzxx;
        self.check = model.checks;
        self.checkHeight = [self caculateRowHeightWithString:model.checks textViewWidth:ScreenWidth - 110];
        self.harris = model.harris;
        self.hss = model.hss;
        self.sf = model.sf;
        self.hpi = model.hpi;
        self.allergy = model.allergy;
        self.allergyHeight = [self caculateRowHeightWithString:model.allergyName textViewWidth:ScreenWidth - 135];
        self.allergyName = model.allergyName;
       
        self.chief = model.chief;
        self.chiefHeight =[self caculateRowHeightWithString:model.chief textViewWidth:ScreenWidth - 110];
        
        self.diagnosis = model.diagnosis;
        self.diagnosisHeight = [self caculateRowHeightWithString:model.diagnosis textViewWidth:ScreenWidth - 110];
        self.ecg = model.ecg;
        self.ecgName = model.ecgName;
        self.ecgHeight = [self caculateRowHeightWithString:model.ecgName textViewWidth:ScreenWidth - 135];
        self.imaging = model.imaging;
        self.imagingName = model.imagingName;
        self.imagingHeight = [self caculateRowHeightWithString:model.imagingName textViewWidth:ScreenWidth - 135];
        self.history = model.history;
        self.historyHeight = [self caculateRowHeightWithString:model.history textViewWidth:ScreenWidth - 110];
        self.hpiHeight = [self caculateRowHeightWithString:model.hpi textViewWidth:ScreenWidth - 110];
        self.joints = model.joints;
        self.harrisuid = model.harrisuid;
        self.hssuid = model.hssuid;
        self.sfuid = model.sfuid;
        self.hzxx = model.hzxx;
        self.forms = model.forms;
    }
    return self;
}
-(CGFloat)caculateRowHeightWithString:(NSString *)content textViewWidth:(CGFloat)width{
    NSDictionary * attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0], NSFontAttributeName,nil];
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size.height+10;
}
@end
