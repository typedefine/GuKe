//
//  PatientRecordInfoManageHeaderView.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientInfoManageHeaderView.h"

@interface PatientInfoManageHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PatientInfoManageHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = Color_rgba(242, 241, 247, 1);//[UIColor colorWithRed:242/255.0 green:241/255.0 blue:247/255.0 alpha:1];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = greenC;
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(10);
            make.centerY.equalTo(bgView);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(16);
        }];
        [bgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).with.offset(8);
            make.centerY.equalTo(bgView);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = SetColor(0x1a1a1a);
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    }
    return _titleLabel;
}

@end
