//
//  WYYSouSuoYishengTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/16.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYSouSuoYishengTableViewCell.h"

@implementation WYYSouSuoYishengTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(WYYSearchYishengModel *)model{
    [self.imgVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,model.portrait]] placeholderImage:[UIImage imageNamed:@"头像"]];
    
    NSString *sex = [NSString stringWithFormat:@"%@",model.gender];
    if ([sex isEqualToString:@"1"]) {
        self.nameLab.text = [NSString stringWithFormat:@"%@    男   %@岁",model.doctorName,model.birthtime];
    }else{
        self.nameLab.text = [NSString stringWithFormat:@"%@  女   %@岁",model.doctorName,model.birthtime];
    }
    
    
    self.zhiweiLab.layer.masksToBounds = YES;
    self.zhiweiLab.layer.cornerRadius = 2;
    self.zhiweiLab.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.02, 0.64, 0.48, 1 });
    [self.zhiweiLab.layer setBorderColor:colorref];//边框颜色
    
    
    
    
    self.yiyuanLab.text = [NSString stringWithFormat:@"%@ | %@",model.hosptialName,model.deptName];
    self.keshiLab.text = [NSString stringWithFormat:@"%@",model.specialtyName];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
