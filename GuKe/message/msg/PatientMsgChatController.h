//
//  PatientBookController.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/19.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatientMsgChatController : UIViewController

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy, nonnull) NSString *sessionid;//app端用户登录session
@property (nonatomic, copy, nonnull) NSString *recipient;//消息列表接口返回的sender字段
@property (nonatomic, copy, nonnull) NSString *hospnumId;//患者ID

@end

NS_ASSUME_NONNULL_END
