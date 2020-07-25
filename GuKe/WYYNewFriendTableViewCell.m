//
//  WYYNewFriendTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/18.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYNewFriendTableViewCell.h"

@implementation WYYNewFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 21;
    
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.cornerRadius = 2;
    // Initialization code
}
- (void)setModel:(WYYAddFriendList *)model{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,model.portrait]] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.titleLab.text = [NSString stringWithFormat:@"%@",model.userName];
    self.detailLab.text = [NSString stringWithFormat:@"%@",model.content];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
