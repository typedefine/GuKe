//
//  SysMessageTewCell.m
//  GuKe
//
//  Created by MYMAc on 2019/3/19.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "SysMessageTewCell.h"

@implementation SysMessageTewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(MessageModels *)model{
    _model = model;
    self.MessageTime.text = model.time;
    self.MessageTitle.text = model.title;
    self.Messconcent.text = model.des;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
