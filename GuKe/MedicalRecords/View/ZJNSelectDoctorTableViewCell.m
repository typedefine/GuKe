//
//  ZJNSelectDoctorTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/1.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNSelectDoctorTableViewCell.h"

@implementation ZJNSelectDoctorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImageV];
        [self.headImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(46, 46));
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.headImageV.mas_right).offset(20);
            make.height.equalTo(@20);
        }];
        
        [self.contentView addSubview:self.selectImageV];
        [self.selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-13);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
    return self;
}
-(UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc]init];
        [Utile makeCorner:23 view:_headImageV];
    }
    return _headImageV;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = SetFont(15);
        _nameLabel.textColor = SetColor(0x1a1a1a);
    }
    return _nameLabel;
}
-(UIImageView *)selectImageV{
    if (!_selectImageV) {
        _selectImageV = [[UIImageView alloc]init];
        
    }
    return _selectImageV;
}
-(void)selectButtonClick{
    NSLog(@"选中了这个医生");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.selectImageV.image = [UIImage imageNamed:@"选医院"];
    }else{
        self.selectImageV.image = [UIImage imageNamed:@"选医院_未"];
    }
    // Configure the view for the selected state
}

@end
