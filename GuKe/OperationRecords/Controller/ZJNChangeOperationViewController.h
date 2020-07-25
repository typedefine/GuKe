//
//  ZJNChangeOperationViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNChangeOperationRequestModel.h"
@interface ZJNChangeOperationViewController : UIViewController
@property (nonatomic ,strong)ZJNChangeOperationRequestModel *requestModel;
@property (nonatomic ,copy)void (^refershOperationInfo)(void);
@end
