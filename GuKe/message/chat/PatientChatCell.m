//
//  PatientChatCell.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientChatCell.h"
#import "PatientMsgChatCellModel.h"

@interface PatientChatCell()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation PatientChatCell
{
    PatientChatCellBlock _action;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
            make.height.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.portraitImageView];
        [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(30);
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        }];
        
        [self.portraitImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portraitImageView).offset(10);
            make.left.equalTo(self.portraitImageView.mas_right).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return self;
}

- (void)tapAction
{
    if (_action) {
        _action();
    }
}

- (void)configureCellWithData:(PatientMsgChatCellModel *)data action:(PatientChatCellBlock)action
{
    _action = action;
    self.timeLabel.text = data.time;
    self.contentLabel.text = data.content;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = SetColor(0x999999);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIImageView *)portraitImageView
{
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] init];
        _portraitImageView.image = [UIImage imageNamed:@"default_avatar"];
        _portraitImageView.userInteractionEnabled = YES;
    }
    return _portraitImageView;
}


- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = SetColor(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
