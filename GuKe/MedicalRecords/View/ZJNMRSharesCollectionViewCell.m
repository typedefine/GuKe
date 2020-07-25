//
//  ZJNMRSharesCollectionViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2018/1/31.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNMRSharesCollectionViewCell.h"

@implementation ZJNMRSharesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat imageHeight = (ScreenWidth-70)/6.0-10;
    self.imageHeightConstraint.constant = imageHeight;
    [Utile makeCorner:imageHeight/2.0 view:self.imageView];
    // Initialization code
}

@end
