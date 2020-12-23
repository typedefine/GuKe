//
//  ZXFInputViewCell.m
//  GuKe
//
//  Created by yb on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//


#import "ZXFInputViewCell.h"

@interface ZXFInputViewCell ()<UITextViewDelegate>


@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, copy) inputAction input;

@end

@implementation ZXFInputViewCell



- (void)setup
{
    [super setup];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
//    bgView.layer.borderWidth = 1.0f;
//    bgView.layer.borderColor = SetColor(0x333333).CGColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(15);
        make.right.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(bgView).offset(8);
        make.right.bottom.equalTo(bgView).offset(-8);
    }];

    [self.textView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView).offset(5);
        make.top.equalTo(self.textView).offset(8);
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.placeholderLabel.hidden = NO;
}

- (void)configureWithTitle:(NSString *)title content:(NSString *)content input:(inputAction)input
{
    self.titleLabel.text = title;
    if (content.isValidStringValue) {
        self.textView.text = content;
        self.placeholderLabel.hidden = YES;
    }
    self.input = [input copy];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.input) {
        self.input(textView.text);
    }
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = SetColor(0x666666);
        _textView.font = Font14;
        _textView.tintColor = greenC;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = SetColor(0x999999);
        _placeholderLabel.font = Font14;
        _placeholderLabel.text = @"请输入提醒内容";
    }
    return _placeholderLabel;
}




@end
