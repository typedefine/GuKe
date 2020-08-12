//
//  PatientRecordFitMentionCell.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientRecordFitMentionCell.h"

@interface PatientRecordFitMentionCell ()<UITextViewDelegate>

@end

@implementation PatientRecordFitMentionCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.borderWidth = 1.0f;
        bgView.layer.borderColor = SetColor(0x333333).CGColor;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
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
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textColor = SetColor(0x666666);
        _textView.font = Font14;
        _textView.tintColor = greenC;
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
