//
//  Follow-UpRecordsViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Follow_UpRecordsViewController : UIViewController
@property (nonatomic ,strong)NSDictionary *patientInfoDic;
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic;
@end
