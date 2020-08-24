//
//  PatientCellModel.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PatientMessageModel;
@interface PatientBookCellModel : NSObject

@property (nonatomic, copy) NSString *portraitUrl;
@property (nonatomic, copy) NSString *patientName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *replyTitle;
@property (nonatomic, strong) PatientMessageModel *model;


@end

NS_ASSUME_NONNULL_END
