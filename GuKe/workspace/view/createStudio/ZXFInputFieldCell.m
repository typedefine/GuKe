//
//  ZXFInputFieldCell.m
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFInputFieldCell.h"
//#import "ZXFInputBaseCell.h"


@interface ZXFInputFieldCell ()<UITextFieldDelegate>

@property(nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) void (^ completion)(NSString *text);
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZXFInputFieldCell

- (void)setup
{
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(IPHONE_X_SCALE(20));
        make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
    }];
}


- (void)configWithTitle:(NSString *)title
            placeholder:(NSString *)placeholder
             completion:(void (^)(NSString *text))completion
{
    if (title.isValidStringValue) {
        self.title = title;
    }
    
    if (placeholder.isValidStringValue) {
        self.placeholder = placeholder;
    }
    
    if (placeholder.isValidStringValue) {
        self.textField.placeholder = placeholder;
    }
    self.completion = [completion copy];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.completion) {
        self.completion(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
//    [self.textField endEditing:YES];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = detailTextColor;
        
        _textField.delegate = self;
    }
    return _textField;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName:[UIColor colorWithHex:0xD0D0D0]
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

@end

