//
//  ZJNSelectGenderTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/5.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNSelectGenderTableViewCell.h"

@implementation ZJNSelectGenderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.rightButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.height.equalTo(@20);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@20);
        }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.rightLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.rightButton.mas_left).offset(-5);
            make.height.equalTo(@20);
        }];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.leftLabel.mas_left);
            make.size.equalTo(self.rightButton);
        }];
        
    }
    return self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = SetFont(14);
        _titleLabel.textColor = SetColor(0x1a1a1a);
    }
    return _titleLabel;
}
-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = SetFont(14);
        _leftLabel.textColor = SetColor(0x666666);
    }
    return _leftLabel;
}
-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = SetFont(14);
        _rightLabel.textColor = SetColor(0x666666);
    }
    return _rightLabel;
}
-(void)leftButtonClick{
    
}

-(void)rightButtonClick{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
