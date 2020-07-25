//
//  ShuHouSUFangViewController.h
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShuHouSUFangViewController : UIViewController
@property (nonatomic,strong)NSString *stringStr;
@property (nonatomic,strong)NSString *hospitalID;
@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,assign)int numbers;
@property (nonatomic,assign)int share;// 0 自己创建的病例可以修改  1 共享的病例不能修改
@property (nonatomic,strong)NSString *zhuyuanhao;//住院号 特定页面使用
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic;
@end
