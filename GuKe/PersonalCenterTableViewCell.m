//
//  PersonalCenterTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "PersonalCenterTableViewCell.h"

@implementation PersonalCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerBgView.backgroundColor = [UIColor colorWithColor:[UIColor whiteColor] alpha:0.5];
    [Utile makeCorner:31 view:self.headerBgView];
    [Utile makeCorner:30 view:self.headerImageView];

    [self bringSubviewToFront:self.backButton];
    if (ScreenHeight>736) {
        if ([ZJNDeviceInfo deviceIsPhone]) {
            self.pCLabelTopConstraint.constant = 56;
        }
    }
}
-(void)setModel:(UserInfoModel *)model{
    _model = model;
    if ([self.model.gender isEqualToString:@"0"]) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,self.model.portrait]] placeholderImage:[UIImage imageNamed:@"女 头像"]];

    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,self.model.portrait]] placeholderImage:[UIImage imageNamed:@"男 头像"]];

    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[NSString changeNullString:self.model.doctorName]];
    
    //计算医生职称字符串宽度
    NSString *doctorTitleStr = [NSString stringWithFormat:@"%@",[NSString changeNullString:self.model.titleName]];
    if (doctorTitleStr.length == 0) {
        
    }else{
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
        
        CGFloat width = [doctorTitleStr boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
        
        self.doctorTitleLabel.text = doctorTitleStr;
        
        self.titleLabelWidthConstraint.constant = width+10;
        
        [Utile makeCorner:3 view:self.doctorTitleLabel];
        [Utile makecorner:1 view:self.doctorTitleLabel color:[UIColor whiteColor]];
    }

    if (self.model.deptName.length == 0) {
        self.hospitalLabel.text = [NSString stringWithFormat:@"%@",[NSString changeNullString:self.model.hospitalName]];
    }else{
        self.hospitalLabel.text = [NSString stringWithFormat:@"%@|%@",[NSString changeNullString:self.model.hospitalName],[NSString changeNullString:self.model.deptName]];
    }
    
    if ([self.model.status isEqualToString:@"1"]) {
        //已认证 图片不隐藏
        self.verifyImageView.hidden = NO;
    }else{
        self.verifyImageView.hidden = YES;
    }
}
//跳转到详细信息页面
- (IBAction)goToDoctorDetailnfoView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personalCenterShowDoctorDetailInfo)]) {
        [self.delegate personalCenterShowDoctorDetailInfo];
    }
}
//跳转到聊天消息页面
- (IBAction)goToDoctorChatView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personalCenterShowDoctorChatHistory)]) {
        [self.delegate personalCenterShowDoctorChatHistory];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
