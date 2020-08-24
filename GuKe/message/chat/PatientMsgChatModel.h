//
//  PatientMsgChatModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GJObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientMsgChatModel : GJObject

@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *recipient;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *readTime;
@property (nonatomic, copy) NSString *medicalTime;


@end

NS_ASSUME_NONNULL_END
