//
//  MoreGroupMemberCell.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "MoreGroupMemberCell.h"


@implementation MoreGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.portraitView.image = [UIImage imageNamed:@"icon_more"];
    }
    return self;
}

@end
