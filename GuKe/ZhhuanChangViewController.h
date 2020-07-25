//
//  ZhhuanChangViewController.h
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnZhuanChang)(NSMutableArray *);//选关节
typedef void(^returnZhuanPerinfo) (NSMutableArray *);////选专长
@interface ZhhuanChangViewController : UIViewController

@property (nonatomic,copy)returnZhuanChang returnZhuan;//选关节
@property (nonatomic,copy)returnZhuanPerinfo returnChang;//选专长
- (void)returnZhuan:(returnZhuanChang)block;//选关节
- (void)returnchang:(returnZhuanPerinfo)block;//选专长

@property (nonatomic,strong)NSArray  *selectArray;
@property (nonatomic,strong)NSString *typeStr;//1 关节  2 专长
@end
