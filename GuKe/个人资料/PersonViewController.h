//
//  PersonViewController.h
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController
@property (assign, nonatomic) BOOL  pushcoming;
@property (nonatomic ,copy)void(^submitInfoSucess)();
@end
