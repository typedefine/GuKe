//
//  ZJNAddPatientOperationInfoViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/5.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNAddOperationRequestModel.h"
@interface ZJNAddPatientOperationInfoViewController : UIViewController

@property (nonatomic ,strong)NSDictionary *patientInfoDic;
@property (nonatomic ,strong)NSString *zhuyuanhao;//从单聊详情的病例跳转时  ，住院号
@property (nonatomic ,strong)ZJNAddOperationRequestModel *requestModel;

@end
