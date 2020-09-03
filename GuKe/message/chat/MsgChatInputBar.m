//
//  MsgChatInputBar.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/25.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "MsgChatInputBar.h"



@interface MsgChatInputBar ()<UITextViewDelegate>{
    CGSize _sendButtonSize;
    CGFloat _maxTextViewWidth;
    CGFloat _bottomHeight;
    CGSize _initBarSize;
}

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
//@property (nonatomic, copy) inputChanged input;

@end

@implementation MsgChatInputBar
@synthesize textSize, barSize;


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _initBarSize = frame.size;
        barSize = _initBarSize;
        _bottomHeight = _initBarSize.height - 49;
        self.backgroundColor = SetColor(0xE8E8E8);
        _sendButtonSize = CGSizeMake(60, 40);
        
        [self addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(_sendButtonSize.width);
            make.height.mas_equalTo(_sendButtonSize.height);
            make.top.equalTo(self).offset(5);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.borderWidth = 1.0f;
        bgView.layer.borderColor = SetColor(0x333333).CGColor;
        bgView.layer.cornerRadius = 5.0f;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(6);
            make.bottom.equalTo(self).offset(-6);
            make.right.equalTo(self.sendButton.mas_left).offset(-15);
        }];
        
        _maxTextViewWidth = _initBarSize.width - _sendButtonSize.width - 15*3 - 2*8;
        
        [bgView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(8);
            make.right.equalTo(bgView).offset(-8);
            make.top.equalTo(bgView).offset(5);
            make.bottom.equalTo(bgView).offset(-5-_bottomHeight);
        }];
    
        [self.textView addSubview:self.placeholderLabel];
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView).offset(5);
//            make.top.equalTo(self.textView).offset(5);
            make.centerY.equalTo(self.sendButton);
        }];
    }
    return self;
}


//- (void)configureWithInput:(inputChanged)input
//{
//    self.input = [input copy];
//}


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
    self.sendButton.enabled = textView.text.isValidStringValue;
    textSize = [Tools sizeOfText:textView.text andMaxSize:CGSizeMake(_maxTextViewWidth, CGFLOAT_MAX) andFont:textView.font];
    barSize.height = MAX(_initBarSize.height, MIN(textSize.height*1.5+_bottomHeight+20, 60));
    CGRect f = self.frame;
    f.size = barSize;
    self.frame = f;
//    if (self.input) {
//        self.input(textView.text, textHeight, textHeight+16);
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarChanged:)]) {
        [self.delegate inputBarChanged:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= 512 && text.length > 0) {
        return NO;
    }
    return YES;
}



- (NSString *)text
{
    return self.textView.text;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
//        _textView.scrollEnabled = NO;
//        _textView.contentInset =
//        _textView.backgroundColor = SetColor(0xE8E8E8);
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
        _placeholderLabel.text = @"请输入内容";
    }
    return _placeholderLabel;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendButton setTitleColor:SetColor(0x666666) forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.layer.borderColor = SetColor(0x999999).CGColor;
        _sendButton.layer.borderWidth = 1;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.cornerRadius = 5;
        [_sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.enabled = NO;
    }
    return _sendButton;
}

- (void)sendButtonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBarSendAction:)]) {
        [self.delegate inputBarSendAction:self];
    }
    [self performSelector:@selector(reset) withObject:nil afterDelay:0.05];
}

- (void)reset
{
    [UIView animateWithDuration:0.3 animations:^{
        self.textView.text = @"";
        self.bounds = CGRectMake(0, 0, _initBarSize.width, _initBarSize.height);
    }];
}

@end
