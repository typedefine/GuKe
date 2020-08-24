//
//  PatientBookPageModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientBookCellModel.h"
#import "PatientMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientBookPageModel : NSObject

@property (nonatomic, copy) NSString *loadUrl;
@property (nonatomic, copy) NSString *msgPrint;
@property (nonatomic, copy) NSString *sessionId;

@property(nonatomic, strong) NSArray<PatientBookCellModel *> *cellModelList;

- (void)configureWithData:(NSArray *)data;


@end

NS_ASSUME_NONNULL_END
