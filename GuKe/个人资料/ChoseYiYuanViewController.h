//
//  ChoseYiYuanViewController.h
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,selectyiyuanStyle){
    selectYiYuan = 0,//医院
    
};
typedef void (^returnYiYuan)(NSDictionary *);//医院
@interface ChoseYiYuanViewController : UIViewController
@property (nonatomic,copy)returnYiYuan returnYuan;
@property (nonatomic,copy)void(^EditHospitalBlock)(NSString* hospitalStr,NSString * departStr);

@property (nonatomic,assign)selectyiyuanStyle *style;
- (void)returnYiYUan:(returnYiYuan)block;
- (instancetype)initWithStyle:(selectyiyuanStyle)style;
@end
