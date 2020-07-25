//
//  ZJNAddDoctorView.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/23.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNAddDoctorView.h"
@interface ZJNAddDoctorView()
@property (nonatomic ,strong)UIView     *bgView;
@property (nonatomic ,strong)UILabel    *titleLabel;
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)UIButton   *cancelButton;
@property (nonatomic ,strong)UIButton   *okButton;
@end
@implementation ZJNAddDoctorView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:self.bgView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth-96, 0.64*(ScreenWidth-96)));
        }];

    }
    return self;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [Utile makeCorner:10 view:_bgView];
        [_bgView addSubview:self.titleLabel];
        [_bgView addSubview:self.textView];
        [_bgView addSubview:self.cancelButton];
        [_bgView addSubview:self.okButton];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_bgView).mas_offset(UIEdgeInsetsMake(15, 10, 0, 10));
            make.height.equalTo(@20);
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
            make.left.bottom.right.equalTo(_bgView).mas_offset(UIEdgeInsetsMake(0, 29, 67, 29));
            
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView);
            make.right.equalTo(self.okButton.mas_left).offset(-13);
            make.top.equalTo(self.textView.mas_bottom).offset(13);
            make.width.equalTo(self.okButton);
            make.height.equalTo(@35);
        }];
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cancelButton);
            make.right.equalTo(self.textView);
            make.width.equalTo(self.cancelButton);
            make.height.equalTo(@35);
        }];
    }
    return _bgView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = SetFont(18);
        _titleLabel.textColor = SetColor(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"备注";
    }
    return _titleLabel;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = SetFont(13);
        _textView.textColor = SetColor(0x666666);
        _textView.layer.borderColor = SetColor(0xe6e6e6).CGColor;
        _textView.layer.borderWidth = 1;
        [Utile makeCorner:5 view:_textView];
        UILabel *placeholderLabel = [[UILabel alloc]init];
        placeholderLabel.font = SetFont(13);
        placeholderLabel.textColor = SetColor(0x999999);
        placeholderLabel.text = @"请输入备注";
        [_textView addSubview:placeholderLabel];
        [_textView setValue:placeholderLabel forKey:@"_placeholderLabel"];
        
//        ZJNUserInfoModel *model = [[ZJNFMDBManager shareFMDBManager]getUserInfoWithUserID:UserId];
//        _textView.text = [NSString stringWithFormat:@"我是%@",model.userName];
        
    }
    return _textView;
}
-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:SetColor(0xcccccc)];
        [Utile makeCorner:5 view:_cancelButton];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okButton setBackgroundColor:SetColor(0x06a27b)];
        [Utile makeCorner:5 view:_okButton];
        [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}
-(void)cancelButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnAddDoctorViewCancelButtonClick)]) {
        [self.delegate zjnAddDoctorViewCancelButtonClick];
    }
}
-(void)okButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnAddDoctorViewOkButtonClickWithContent:)]) {
        [self.delegate zjnAddDoctorViewOkButtonClickWithContent:self.textView.text];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
