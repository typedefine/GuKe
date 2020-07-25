//
//  QJCEdithospitalViewController.h
//  GuKe
//
//  Created by MYMAc on 2019/2/27.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QJCEdithospitalViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *HospitalTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopHeight;
@property (copy, nonatomic) void(^MakeHospitalBlock)(NSString * hospital ,NSString *department);


- (IBAction)SureAction:(id)sender;



@end

NS_ASSUME_NONNULL_END
