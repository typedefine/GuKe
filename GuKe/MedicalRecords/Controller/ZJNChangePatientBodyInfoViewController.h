//
//  ZJNChangePatientBodyInfoViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNChangePatientBodyInfoModel.h"
@interface ZJNChangePatientBodyInfoViewController : UIViewController
@property (nonatomic ,strong)ZJNChangePatientBodyInfoModel *infoModel;
@property (nonatomic ,copy)void(^refreshBodyInfoBlock)();
@end
