//
//  ZJNTitleAndInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/5.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNTitleAndInfoTableViewCell.h"

@implementation ZJNTitleAndInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.infoLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.height.equalTo(@20);
        }];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@20);
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
-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textAlignment = NSTextAlignmentRight;
        _infoLabel.font = SetFont(14);
        _infoLabel.textColor = SetColor(0x666666);
    }
    return _infoLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
