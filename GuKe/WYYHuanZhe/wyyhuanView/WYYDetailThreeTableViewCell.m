//
//  WYYDetailThreeTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/31.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYDetailThreeTableViewCell.h"

@implementation WYYDetailThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(WYYDetailHuanModel *)model{
    self.oneLab.text = [NSString stringWithFormat:@"主治医师:%@   住院号:%@",model.doctorName,model.hospNum];
    self.twoLab.text = [NSString stringWithFormat:@"诊断情况:%@",model.diagnosis];
    self.threeLab.text = [NSString stringWithFormat:@"诊疗时间:%@   医院:%@",model.inTime,model.hospitalName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
