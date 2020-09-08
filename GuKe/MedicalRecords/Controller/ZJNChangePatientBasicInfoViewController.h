//
//  ZJNChangePatientBasicInfoViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNChangePatientBasicInfoModel.h"

@interface ZJNChangePatientBasicInfoViewController : UIViewController
//@property (nonatomic, assign) BOOL isfromPatientMsg;
@property (nonatomic ,strong)ZJNChangePatientBasicInfoModel *infoModel;
@property (nonatomic ,copy)void(^refershPatientInfo)();
@end
