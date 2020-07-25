//
//  ChangeGeRenInfoViewController.h
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, selectStyle){
    selectjianjie = 0,//简介
   // selectZhuanChang = 1,//选专长
    
};
typedef void (^returnJianJie)(NSString *);//简介
@interface ChangeGeRenInfoViewController : UIViewController

@property (nonatomic,copy)returnJianJie returnJIan;
@property (nonatomic,assign)selectStyle *style;
- (void)returnJInaJIe:(returnJianJie)block;
- (instancetype)initWithStyle:(selectStyle)style;


@end
