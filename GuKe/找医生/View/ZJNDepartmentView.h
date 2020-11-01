//
//  ZJNDepartmentView.h
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNDepartmentViewDelegate<NSObject>
-(void)zjnDeptViewSelectedDepartmentWithID:(NSString *)deptID;
-(void)zjnDeptViewCanceled;

@end
@interface ZJNDepartmentView : UIView
@property (nonatomic ,weak)id<ZJNDepartmentViewDelegate>delegate;
-(void)loadDataWithHospitalId:(NSNumber *)hospitalId completion:(void (^)())completion;
@end
