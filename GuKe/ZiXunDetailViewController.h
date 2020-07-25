//
//  ZiXunDetailViewController.h
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiXunDetailViewController : UIViewController
@property (nonatomic,strong)NSString *zixunID;
@property (nonatomic,strong)NSString *typeStr;//1 收藏
@property (nonatomic,strong)NSString *collectID;//收藏id
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *contentStr;
@property (nonatomic,strong)NSString *iconImagePath;
@property (nonatomic,copy)void(^refershCollectStatusBlock)(NSString *shou);
@end
