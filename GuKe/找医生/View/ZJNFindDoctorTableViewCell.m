//
//  ZJNFindDoctorTableViewCell.m
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/22.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import "ZJNFindDoctorTableViewCell.h"
@interface ZJNFindDoctorTableViewCell()
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel     *doctorInfoLabel;
@property (nonatomic ,strong)UILabel     *titleLabel;
@property (nonatomic ,strong)UILabel     *hospADeptLabel;
@property (nonatomic ,strong)UILabel     *goodLabel;
@end
@implementation ZJNFindDoctorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.doctorInfoLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.hospADeptLabel];
        [self.contentView addSubview:self.goodLabel];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(26, 10, 0, 0));
            make.size.mas_equalTo(CGSizeMake(56, 56));
        }];
        [self.doctorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(22);
            make.left.equalTo(self.headImageView.mas_right).offset(12);
            make.right.equalTo(self.titleLabel.mas_left).offset(-10);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(22, 0, 0, 10));
            make.width.lessThanOrEqualTo(@100);
            make.height.equalTo(@20);
        }];
        [self.hospADeptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.doctorInfoLabel.mas_bottom).offset(10);
            make.left.equalTo(self.doctorInfoLabel);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        [self.goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.doctorInfoLabel);
            make.top.equalTo(self.hospADeptLabel.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        [Utile makeCorner:28 view:_headImageView];
    }
    return _headImageView;
}
-(UILabel *)doctorInfoLabel{
    if (!_doctorInfoLabel) {
        _doctorInfoLabel = [[UILabel alloc]init];
        _doctorInfoLabel.font = SetFont(14);
        _doctorInfoLabel.textColor = SetColor(0x1a1a1a);
    }
    return _doctorInfoLabel;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = SetColor(0x00ad82);
        _titleLabel.font = SetFont(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [Utile makeCorner:5 view:_titleLabel];
        _titleLabel.layer.borderColor = SetColor(0x00ad82).CGColor;
        _titleLabel.layer.borderWidth = 1;
    }
    return _titleLabel;
}
-(UILabel *)hospADeptLabel{
    if (!_hospADeptLabel) {
        _hospADeptLabel = [[UILabel alloc]init];
        _hospADeptLabel.font = SetFont(12);
        _hospADeptLabel.textColor = SetColor(0x1a1a1a);
    }
    return _hospADeptLabel;
}
-(UILabel *)goodLabel{
    if (!_goodLabel) {
        _goodLabel = [[UILabel alloc]init];
        _goodLabel.textColor = SetColor(0x999999);
        _goodLabel.font = SetFont(12);
    }
    return _goodLabel;
}
-(void)setModel:(ZJNMyDoctorListModel *)model{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,self.model.portrait]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    
    CGFloat titleWidth = [Utile returnTextSizeWithText:self.model.titleName size:CGSizeMake(100, 20) font:12].width;
    titleWidth = titleWidth>0?titleWidth+8:titleWidth;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(22, 0, 0, 10));
        make.width.mas_equalTo(titleWidth);
        make.height.equalTo(@20);
    }];
    self.titleLabel.text = self.model.titleName;
    NSString *sexStr = [NSString stringWithFormat:@"%@",model.gender];
    if ([sexStr isEqualToString:@"0"]) {
        self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@  %@  %@",self.model.doctorName,@"女",model.birthtime];
    }else{
        self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@  %@  %@",self.model.doctorName,@"男",model.birthtime];
    }
    
    self.hospADeptLabel.text = [NSString stringWithFormat:@"%@|%@",self.model.hosptialName,self.model.deptName];
    [Utile setUILabel:self.hospADeptLabel data:self.model.hosptialName setData:@"|" color:SetColor(0x999999) font:10 underLine:NO];
    self.goodLabel.text = [NSString stringWithFormat:@"擅长：%@",self.model.specialtyName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
