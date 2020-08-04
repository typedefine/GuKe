//
//  PatientRecordInfoManageHeaderView.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientRecordInfoManageHeaderView.h"

@interface PatientRecordInfoManageHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PatientRecordInfoManageHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.centerY.equalTo(self);
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
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    }
    return _titleLabel;
}

@end
