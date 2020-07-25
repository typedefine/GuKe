//
//  ZJNAddDoctorView.h
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/23.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNAddDoctorViewDelegate<NSObject>
-(void)zjnAddDoctorViewCancelButtonClick;
-(void)zjnAddDoctorViewOkButtonClickWithContent:(NSString *)content;
@end
@interface ZJNAddDoctorView : UIView
@property (nonatomic ,weak)id<ZJNAddDoctorViewDelegate>delegate;
@end
