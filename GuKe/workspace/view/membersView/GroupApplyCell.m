//
//  GroupApplyCell.m
//  GuKe
//
//  Created by yb on 2021/3/8.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupApplyCell.h"

@implementation GroupApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.acceptButton];
        [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(35);
        }];
        self.acceptButton.clipsToBounds = YES;
        self.acceptButton.layer.cornerRadius = 17;
        
        [self.contentView addSubview:self.refuseButton];
        [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.acceptButton.mas_left).offset(-20);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(35);
        }];
        self.refuseButton.clipsToBounds = YES;
        self.refuseButton.layer.cornerRadius = 17;
        self.refuseButton.layer.borderWidth = 1;
        self.refuseButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.refuseButton.hidden = YES;
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}

- (UIButton *)acceptButton
{
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _acceptButton.backgroundColor = greenC;
        _acceptButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_acceptButton setTitle:@"接受" forState:UIControlStateNormal];
        [_acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _acceptButton;
}


- (UIButton *)refuseButton
{
    if (!_refuseButton) {
        _refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseButton.backgroundColor = [UIColor whiteColor];
        _refuseButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _refuseButton;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
