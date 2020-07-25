//
//  WYYChoseGroupNumberViewController.h
//  GuKe
//
//  Created by yu on 2018/1/22.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,selectTheContectStyle) {
    addGroup  = 0,//创建小组
    addFriend,//群组拉人
};
typedef void (^backGroupNumber) (NSMutableArray *groupDic);//创建群组
typedef void (^backAddNumber) (NSMutableArray *numberArr);//群组拉人
@interface WYYChoseGroupNumberViewController : UIViewController
@property (nonatomic,copy)backGroupNumber backgroupnumber;//创建群组
@property (nonatomic,copy)backAddNumber backaddnumber;////群组拉人
@property (nonatomic ,assign)selectTheContectStyle style;
@property (nonatomic,strong)NSArray *GroupNumberArr;//群成员是否在里面
@end
