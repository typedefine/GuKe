//
//  ZJNAnesthesiaTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/6.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNAnesthesiaTableViewCell.h"
@interface ZJNAnesthesiaTableViewCell()
{
    UIButton *signButton;
}

@property (nonatomic ,strong)UIButton *moreButton;

@end
@implementation ZJNAnesthesiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.firstButton];
        [self.contentView addSubview:self.firstLabel];
        [self.contentView addSubview:self.secondButton];
        [self.contentView addSubview:self.secondLabel];
        [self.contentView addSubview:self.thirdButton];
        [self.contentView addSubview:self.thirdLabel];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.fourthLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(14, 10, 0, 0));
            
        }];
        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(3);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstButton.mas_right);
            make.centerY.equalTo(self.firstButton);
            make.right.equalTo(self.secondButton.mas_left);
            make.height.equalTo(@20);
        }];
        
        [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(ScreenWidth/2.0);
            make.top.equalTo(self.firstButton);
            make.size.equalTo(self.firstButton);
        }];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.secondButton.mas_right);
            make.centerY.equalTo(self.secondButton);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@20);
        }];
        [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstButton);
            make.top.equalTo(self.firstButton.mas_bottom).offset(1);
            make.size.equalTo(self.firstButton);
        }];
        [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.thirdButton);
            make.left.equalTo(self.thirdButton.mas_right);
            make.width.equalTo(@(ScreenWidth/2.0));
            make.height.equalTo(@20);
        }];
        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.thirdButton);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@250);
            make.centerY.equalTo(self.thirdLabel);
            make.right.equalTo(self.moreButton.mas_left);
            make.height.equalTo(@20);
            
        }];
        [self updateConstraintsIfNeeded];
        signButton = self.firstButton;
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
-(UIButton *)firstButton{
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firstButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_firstButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_firstButton addTarget:self action:@selector(firstButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}
-(UIButton *)secondButton{
    if (!_secondButton) {
        _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secondButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_secondButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_secondButton addTarget:self action:@selector(secondButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}
-(UIButton *)thirdButton{
    if (!_thirdButton) {
        _thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thirdButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_thirdButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_thirdButton addTarget:self action:@selector(thirdButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdButton;
}
-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"箭头_下"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
-(UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc]init];
        _firstLabel.font = SetFont(14);
        _firstLabel.textColor = SetColor(0x666666);
    }
    return _firstLabel;
}
-(UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc]init];
        _secondLabel.font = SetFont(14);
        _secondLabel.textColor = SetColor(0x666666);
    }
    return _secondLabel;
}
-(UILabel *)thirdLabel{
    if (!_thirdLabel) {
        _thirdLabel = [[UILabel alloc]init];
        _thirdLabel.font = SetFont(14);
        _thirdLabel.textColor = SetColor(0x666666);
    }
    return _thirdLabel;
}
-(UILabel *)fourthLabel{
    if (!_fourthLabel) {
        _fourthLabel = [[UILabel alloc]init];
        _fourthLabel.font = SetFont(14);
        _fourthLabel.textColor = SetColor(0x666666);
        _fourthLabel.userInteractionEnabled = YES ;
        _fourthLabel.textAlignment = NSTextAlignmentRight;
        [_fourthLabel whenTouchedUp:^{
            [self moreButtonClick];
        }];
     }
    return _fourthLabel;
}

-(void)firstButtonClick{
    if (self.firstButton == signButton) {
        return;
    }
    signButton.selected = NO;
    self.firstButton.selected = YES;
    signButton = self.firstButton;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnAnesthesiaTableViewCellSelectButtonWithType:)]) {
        [self.delegate zjnAnesthesiaTableViewCellSelectButtonWithType:@"1"];
    }
}
-(void)secondButtonClick{
    if (self.secondButton == signButton) {
        return;
    }
    signButton.selected = NO;
    self.secondButton.selected = YES;
    signButton = self.secondButton;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnAnesthesiaTableViewCellSelectButtonWithType:)]) {
        [self.delegate zjnAnesthesiaTableViewCellSelectButtonWithType:@"2"];
    }
}
-(void)thirdButtonClick{
    if (self.thirdButton == signButton) {
        return;
    }
    signButton.selected = NO;
    self.thirdButton.selected = YES;
    signButton = self.thirdButton;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnAnesthesiaTableViewCellSelectButtonWithType:)]) {
        [self.delegate zjnAnesthesiaTableViewCellSelectButtonWithType:@"3"];
    }
}
-(void)moreButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zjnAnesthesiaTableViewCellSelectButtonWithType:)]) {
        [self.delegate zjnAnesthesiaTableViewCellSelectButtonWithType:@"4"];
    }
}
-(void)setAnesthesiaUid:(NSString *)anesthesiaUid{
    _anesthesiaUid = anesthesiaUid;
    if ([[NSString stringWithFormat:@"%@",_anesthesiaUid] isEqualToString:@"1"]) {
        self.firstButton.selected = YES;
        signButton = self.firstButton;
    }else if ([[NSString stringWithFormat:@"%@",_anesthesiaUid] isEqualToString:@"2"]){
        self.secondButton.selected = YES;
        signButton = self.secondButton;

    }else{
        self.thirdButton.selected = YES;
        signButton = self.thirdButton;

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
