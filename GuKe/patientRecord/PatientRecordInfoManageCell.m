//
//  PatientRecordInfoManageCell.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientRecordInfoManageCell.h"

@interface PatientRecordInfoManageCell()

@property (nonatomic, strong) UIButton *checkBoxButton;
@property (nonatomic, strong) PatientRecordInfoManageCellModel *cellModel;

@end

@implementation PatientRecordInfoManageCell

- (UIButton *)checkBoxButton
{
    if (!_checkBoxButton) {
        _checkBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxButton setImage:[UIImage imageNamed:@"icon_checkbox"] forState:UIControlStateNormal];
        [_checkBoxButton setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
        _checkBoxButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _checkBoxButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_checkBoxButton setTitleColor:SetColor(0x1a1a1a) forState:UIControlStateNormal];
    }
    return _checkBoxButton;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.checkBoxButton];
        [self.checkBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(120);
        }];
        [self.checkBoxButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clicked:(UIButton *)button
{
     self.cellModel.select = button.selected = !button.selected;
}

- (void)configureWithData:(PatientRecordInfoManageCellModel *)data
{
    self.cellModel = data;
    [self.checkBoxButton setTitle:data.title forState:UIControlStateNormal];
    self.checkBoxButton.selected = data.select;
}

@end
