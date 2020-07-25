//
//  ZJNPatientBodyInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/9.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNPatientBodyInfoTableViewCell.h"
@interface ZJNPatientBodyInfoTableViewCell ()<UITextFieldDelegate>

@end
@implementation ZJNPatientBodyInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Utile makeCorner:5 view:self.tiWenTextField];
    [Utile makeCorner:5 view:self.pulseTextField];
    [Utile makeCorner:5 view:self.breatheTextField];
    [Utile makeCorner:5 view:self.hightBloodPressureTextField];
    [Utile makeCorner:5 view:self.lowBloodPressureTextField];
    
    self.tiWenTextField.delegate = self;
    self.pulseTextField.delegate = self;
    self.breatheTextField.delegate = self;
    self.hightBloodPressureTextField.delegate = self;
    self.lowBloodPressureTextField.delegate = self;
}
#pragma mark--UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSDictionary *dic;
    if (textField == self.tiWenTextField) {
        dic = @{@"type":@"0",@"text":textField.text};
    }else if (textField == self.pulseTextField){
        dic = @{@"type":@"1",@"text":textField.text};
    }else if (textField == self.breatheTextField){
        dic = @{@"type":@"2",@"text":textField.text};
    }else if (textField == self.hightBloodPressureTextField){
        dic = @{@"type":@"3",@"text":textField.text};
    }else{
        dic = @{@"type":@"4",@"text":textField.text};
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnPatientBodyInfoTextDieldEndEditingWithDictionary:)]) {
        [self.delegate zjnPatientBodyInfoTextDieldEndEditingWithDictionary:dic];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
