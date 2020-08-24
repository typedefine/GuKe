//
//  PatientMsgChatPageModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientMsgChatCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientMsgChatPageModel : NSObject

@property (nonatomic, copy) NSString *loadUrl;
@property (nonatomic, copy) NSString *msgPrint;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *recipient;

@property(nonatomic, strong) NSArray<PatientMsgChatCellModel *> *cellModelList;

- (void)configureWithData:(NSArray *)data;


@end

NS_ASSUME_NONNULL_END
