//
//  PatientInfoManageModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/12.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"
@class PatientBookInfoStateModel;
NS_ASSUME_NONNULL_BEGIN

@interface PatientInfoManageModel : GJObject

@property (nonatomic, copy) NSString *follow;//随访记录是否显示  1 显示  0不显示
@property (nonatomic, copy) NSString *operation;//手术记录是否显示  1 显示  0不显示
@property (nonatomic, copy) NSString *visit;//就诊记录是否显示  1 显示  0不显示
@property (nonatomic, copy) NSString *remind;//健康提醒
@property (nonatomic, strong) NSArray<PatientBookInfoStateModel *> *bookInfoStateList;//存放回复记录的集合

@end

NS_ASSUME_NONNULL_END
