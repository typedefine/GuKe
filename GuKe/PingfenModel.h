//
//  PingfenModel.h
//  GuKe
//
//  Created by MYMAc on 2018/6/11.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 fcd = 1526113620000;
 formId = 2;
 formName = "sf\U8bc4\U5206";
 formStatus = 1;
 options = "<null>";
 */
@interface PingfenModel : NSObject
@property (copy, nonatomic) NSString *  formId;
@property (copy, nonatomic) NSString *  formName;
@property (copy, nonatomic) NSString *  formStatus;
@property (copy, nonatomic) NSString *  fcd;
@property (copy, nonatomic) NSString *  saveNumber;
@property (copy, nonatomic) NSString *  options;
@property (copy, nonatomic) NSString *  saveColumn;
 @end

