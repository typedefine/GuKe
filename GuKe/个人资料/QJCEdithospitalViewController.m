//
//  QJCEdithospitalViewController.m
//  GuKe
//
//  Created by MYMAc on 2019/2/27.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "QJCEdithospitalViewController.h"

@interface QJCEdithospitalViewController ()

@end

@implementation QJCEdithospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"医院信息编辑";
    

    self.TopHeight.constant = 40;
    self.SureBtn.layer.masksToBounds = YES;
    self.SureBtn.layer.cornerRadius = 20;
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SureAction:(id)sender {
    if([NSString IsNullStr:self.HospitalTextField.text]){
        [self showHint:@"请输入您的医院名称"];
    }else if([NSString IsNullStr:self.departmentTextField.text]){
        [self showHint:@"请输入您的科室名称"];
    }else{
        if (self.MakeHospitalBlock) {
            self.MakeHospitalBlock(self.HospitalTextField.text, self.departmentTextField.text);
            [self.navigationController popViewControllerAnimated:NO];

        }
        
    }
}
@end
