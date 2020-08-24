//
//  PatientMessageModel.h
//  GuKe
//
//  Created by jiangchen zhou on 2020/8/20.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientMessageModel : GJObject

@property (nonatomic, copy) NSString *msgId;//消息id
@property (nonatomic, copy) NSString *sender;//发送者id
@property (nonatomic, copy) NSString *recipient;//接受者id，此处是医生自己
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, assign) NSInteger isRead;//是否已读
@property (nonatomic, copy) NSString *realName;//显示的姓名
@property (nonatomic, copy) NSString *createTime;//消息的时间
@property (nonatomic, copy) NSString *readTime;//已读时间
@property (nonatomic, copy) NSString *medicalTime;//缺省，预留字段，此接口没有用到

@end

NS_ASSUME_NONNULL_END
