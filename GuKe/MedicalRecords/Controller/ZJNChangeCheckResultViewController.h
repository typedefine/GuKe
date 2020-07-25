//
//  ZJNChangeCheckResultViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNChangeCheckResultModel.h"
@interface ZJNChangeCheckResultViewController : UIViewController
@property (nonatomic ,strong)ZJNChangeCheckResultModel *infoModel;
@property (nonatomic ,copy)void (^refreshMedicalRecord)();
@end
