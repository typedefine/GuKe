//
//  QJCOrderListmodel.m
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import "QJCOrderListmodel.h"
#import "QJCOrderModel.h"
@implementation QJCOrderListmodel

-(void)setUserList:(NSMutableArray *)userList{
     _userList =[[ NSMutableArray alloc]init];
     for (NSDictionary *dic  in userList) {
        QJCOrderModel * mdle = [QJCOrderModel yy_modelWithJSON:dic];
         self.giveSate  =  self.giveSate? self.giveSate:mdle.giveSate;
        [_userList addObject:mdle];
    }
   

}
@end
