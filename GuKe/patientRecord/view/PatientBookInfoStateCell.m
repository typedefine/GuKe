//
//  PatientRecordBookCell.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientBookInfoStateCell.h"



@interface PatientBookInfoStateCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) PatientBookInfoStateCellModel *cellModel;

@end

@implementation PatientBookInfoStateCell

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = SetColor(0x1a1a1a);
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = SetColor(0x666666);
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel.mas_right).offset(30);
            make.centerY.equalTo(self.contentView);
        }];
      
    }
    return self;
}


- (void)configureWithData:(PatientBookInfoStateCellModel *)data
{
    self.cellModel = data;
    self.contentLabel.text = data.title;
    if (data.titleColor) {
        self.contentLabel.textColor = data.titleColor;
    }
    if (data.time) {
        self.timeLabel.text = data.time;
    }
}

@end
