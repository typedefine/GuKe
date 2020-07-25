//
//  ZJNMRShareDoctorViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/1.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNMRShareDoctorViewControllerDelegate<NSObject>
-(void)shareDoctorWithArray:(NSArray *)array;
@end

@interface ZJNMRShareDoctorViewController : UIViewController
@property (nonatomic ,weak)id<ZJNMRShareDoctorViewControllerDelegate>delegate;
@property (nonatomic ,strong)NSArray *dataArr;

@end
