//
//  PatientMsgChatCellModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientMsgChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientMsgChatCellModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *portriatUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *extra;
@property (nonatomic, assign) BOOL isPatient;
@property (nonatomic, strong) PatientMsgChatModel *model;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
