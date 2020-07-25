//
//  ZiXunTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZiXunTableViewCell.h"

@implementation ZiXunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.clipsToBounds = YES;
    // Initialization code
}
- (void)setModel:(ZiXunlistModel *)model{
    _model = model;
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,self.model.image]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@",self.model.title];
    if (model.createTime.length > 10 ) {
        self.timeLab.text = [NSString stringWithFormat:@"%@",[self.model.createTime substringToIndex:10]];
    }else{
        self.timeLab.text = [NSString stringWithFormat:@"%@",self.model.createTime];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
