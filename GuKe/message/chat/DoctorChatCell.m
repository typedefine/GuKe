//
//  DoctorChatCell.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "DoctorChatCell.h"
#import "PatientMsgChatCellModel.h"

@interface DoctorChatCell()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *extraButton;

@end

@implementation DoctorChatCell

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
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portraitImageView).offset(10);
            make.right.equalTo(self.portraitImageView.mas_left).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        [self.contentView addSubview:self.extraButton];
        [self.extraButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
//            make.left.equalTo(self.contentLabel.mas_left);
            make.right.equalTo(self.contentLabel);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(180);
        }];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.extraButton.hidden = YES;
}

- (void)configureCellWithData:(PatientMsgChatCellModel *)data
{
    self.timeLabel.text = data.time;
    self.contentLabel.text = data.content;
    
    if (data.extra && data.extra.length > 0) {
        self.extraButton.hidden = NO;
        [self.extraButton setTitle:data.extra forState:UIControlStateNormal];
    }
}

- (void)extraAction
{
    NSLog(@"extra clicked");
}

- (UIButton *)extraButton
{
    if (!_extraButton) {
        _extraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _extraButton.layer.borderColor = SetColor(0x999999).CGColor;
        _extraButton.layer.borderWidth = 1;
        _extraButton.layer.cornerRadius = 5;
        _extraButton.layer.masksToBounds = YES;
        _extraButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_extraButton setTitleColor:SetColor(0x666666) forState:UIControlStateNormal];
        [_extraButton addTarget:self action:@selector(extraAction) forControlEvents:UIControlEventTouchUpInside];
        _extraButton.hidden = YES;
    }
    return _extraButton;
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
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}


@end

