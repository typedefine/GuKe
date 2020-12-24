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

@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) void (^ completion)(NSString *text);
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZXFInputFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.width.mas_equalTo(IPHONE_X_SCALE(100));
//        make.height.mas_equalTo(20);
    }];
    
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
        _textField.textAlignment =NSTextAlignmentLeft;
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
    if (title.isValidStringValue) {
        self.titleLabel.text = title;
        CGFloat w = [Tools sizeOfText:title andMaxSize:CGSizeMake(CGFLOAT_MAX, 20) andFont:self.titleLabel.font].width + 5;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
            make.width.mas_equalTo(w);
        }];
    }
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}


@end

