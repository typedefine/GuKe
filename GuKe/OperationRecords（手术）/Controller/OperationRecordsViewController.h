//
//  OperationRecordsViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationRecordsViewController : UIViewController
@property (nonatomic ,strong)NSDictionary *patientInfoDic;
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic;
@end
