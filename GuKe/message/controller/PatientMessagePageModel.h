//
//  PatientMessagePageModel.h
//  GuKe
//
//  Created by jiangchen zhou on 2020/8/20.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientMessageCellModel.h"
#import "PatientMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientMessagePageModel : NSObject

@property (nonatomic, copy) NSString *loadUrl;
@property (nonatomic, copy) NSString *msgPrint;
@property (nonatomic, copy) NSString *sessionId;

@property(nonatomic, strong) NSArray<PatientMessageCellModel *> *cellModelList;

- (void)configureWithData:(NSArray *)data;


@end

NS_ASSUME_NONNULL_END
