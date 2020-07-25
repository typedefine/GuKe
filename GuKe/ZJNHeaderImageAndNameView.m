//
//  ZJNHeaderImageAndNameView.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNHeaderImageAndNameView.h"

@implementation ZJNHeaderImageAndNameView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
        [Utile makeCorner:22.5 view:self.headerImageView];
        [self addSubview:self.headerImageView];
        
        self.nameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 45, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.textColor = SetColor(0x666666);
        [self addSubview:self.nameLabel];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
