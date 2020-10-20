//
//  ZJNProvincesView.h
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNProvincesViewDelegate<NSObject>
-(void)provincesViewSearchDoctorWithArea:(NSString *)area hospitalArr:(NSArray *)hospArr;
-(void)provincesViewCanceled;
@end
@interface ZJNProvincesView : UIView
@property (nonatomic ,weak)id<ZJNProvincesViewDelegate>delegate;
@end
