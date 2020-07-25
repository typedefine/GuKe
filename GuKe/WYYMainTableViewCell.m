//
//  WYYMainTableViewCell.m
//  GuKe
//
//  Created by yu on 2018/1/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYMainTableViewCell.h"

@implementation WYYMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utile makeCorner:10 view:self.SearchView];
    [self.SearchView whenTapped:^{
        if(self.searchBlock){
            self.searchBlock();
        }
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
