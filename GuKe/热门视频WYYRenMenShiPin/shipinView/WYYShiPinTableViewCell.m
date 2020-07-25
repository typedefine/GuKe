//
//  WYYShiPinTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/19.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYShiPinTableViewCell.h"

@implementation WYYShiPinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(WYYShiPinModel *)model{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,model.videoImages]] placeholderImage:[UIImage imageNamed:@"default_img"]];
//    self.doctorName.text = [NSString stringWithFormat:@"%@  %@",model.videoName,model.videoSpeaker];
    self.doctorName.text = [NSString stringWithFormat:@"%@",model.videoName];

    [Utile setUILabel:self.doctorName data:nil setData:[NSString stringWithFormat:@"%@",model.videoName] color:SetColor(0x1A1A1A) font:14 underLine:NO];
    
    self.detailLab.text = [NSString stringWithFormat:@"%@\n%@",model.videoSpeaker,[NSString changeNullString:model.videoUnit]];
    self.timeLab.text = [NSString stringWithFormat:@"%@",model.createTime];
    
    self.numLab.text = [NSString stringWithFormat:@"%@",model.videoCount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
