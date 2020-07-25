//
//  OrderTypeModel.h
//  GuKe
//
//  Created by yu on 2018/1/20.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTypeModel : NSObject

@property (nonatomic,strong)NSString *typeName;
@property (nonatomic,strong)NSString *videoTypeId;
@property (nonatomic,strong)NSString *compositor;
@property (nonatomic,strong)NSString *typeParent;

- (void)makeModelWithDic:(NSDictionary *)dic;
@end
