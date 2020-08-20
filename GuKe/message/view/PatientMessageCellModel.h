//
//  PatientMessageCellModel.h
//  GuKe
//
//  Created by jiangchen zhou on 2020/8/20.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PatientMessageModel;
@interface PatientMessageCellModel : NSObject

@property (nonatomic, copy) NSString *patientId;
@property (nonatomic, copy) NSString *portraitUrl;
@property (nonatomic, copy) NSString *patientName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) PatientMessageModel *model;

@end

NS_ASSUME_NONNULL_END
