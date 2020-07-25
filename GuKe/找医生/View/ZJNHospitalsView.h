//
//  ZJNHospitalsView.h
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNHospitalsViewDelegate<NSObject>
-(void)zjnHospitalsViewSelectedHospitalWithHospitalName:(NSString *)hospitalName departmentArr:(NSArray *)deptArr;
@end
@interface ZJNHospitalsView : UIView
@property (nonatomic ,weak)id<ZJNHospitalsViewDelegate>delegate;
-(void)reloadDataWithHospitalArray:(NSArray *)hospArr;
@end
