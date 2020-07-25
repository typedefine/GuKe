//
//  ZJNPatientBodyInfoTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNPatientBodyInfoDelegate<NSObject>
-(void)zjnPatientBodyInfoTextDieldEndEditingWithDictionary:(NSDictionary *)dic;
@end
@interface ZJNPatientBodyInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tiWenTextField;
@property (weak, nonatomic) IBOutlet UITextField *pulseTextField;
@property (weak, nonatomic) IBOutlet UITextField *breatheTextField;
@property (weak, nonatomic) IBOutlet UITextField *hightBloodPressureTextField;
@property (weak, nonatomic) IBOutlet UITextField *lowBloodPressureTextField;
@property(nonatomic ,weak)id<ZJNPatientBodyInfoDelegate>delegate;
@end
