//
//  ZJNSelectHospODeptTableViewCell.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNSelectHospODeptTableViewCell.h"
@interface ZJNSelectHospODeptTableViewCell()

@end
@implementation ZJNSelectHospODeptTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.selectImageView];
        [self.contentView addSubview:self.contentLabel];
        
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(13, 9));
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectImageView.mas_right).offset(4);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-4);
        }];
    }
    return self;
}
-(UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]init];
    }
    return _selectImageView;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = SetColor(0x333333);
        _contentLabel.font = Font14;
    }
    return _contentLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"TICK"];
        _contentLabel.textColor = SetColor(0x06a27b);
    }else{
        self.selectImageView.image = [UIImage imageNamed:@""];
        _contentLabel.textColor = SetColor(0x333333);
    }
    // Configure the view for the selected state
}

@end
