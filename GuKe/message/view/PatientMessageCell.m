//
//  PatientMessageCell.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/19.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientMessageCell.h"
#import "PatientMessageCellModel.h"

@interface PatientMessageCell()

@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, copy) replyBlock reply;
@property (nonatomic, strong) PatientMessageCellModel *cellModel;

@end

@implementation PatientMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.portraitView];
        [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(50);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portraitView).offset(5);
            make.left.equalTo(self.portraitView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.portraitView.mas_right).offset(10);
        }];
        
        [self.contentView addSubview:self.replyButton];
        [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portraitView);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
        }];
        [self.replyButton addTarget:self action:@selector(replyButtonActtion) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)replyButtonActtion
{
    if (self.reply) {
        self.reply(self.cellModel.model);
    }
}

- (void)configureCellWithData:(PatientMessageCellModel *)data reply:(replyBlock)reply
{
    self.cellModel = data;
    if (data.portraitUrl && data.portraitUrl.length > 0) {
        [self.portraitView sd_setImageWithURL:[NSURL URLWithString:data.portraitUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }
    self.nameLabel.text = data.patientName;
    self.contentLabel.text = data.content;
    [self.replyButton setTitle:data.replyTitle forState:UIControlStateNormal];
    self.reply = [reply copy];
}


- (UIImageView *)portraitView
{
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
        _portraitView.image = [UIImage imageNamed:@"default_avatar"];
    }
    return _portraitView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _nameLabel.textColor = SetColor(0x333333);
    }
    return _nameLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = SetColor(0x333333);
    }
    return _contentLabel;
}


- (UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:SetColor(0x666666) forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _replyButton.layer.borderColor = SetColor(0x999999).CGColor;
        _replyButton.layer.borderWidth = 1;
        _replyButton.clipsToBounds = YES;
        _replyButton.layer.cornerRadius = 5;
    }
    return _replyButton;
}

@end
