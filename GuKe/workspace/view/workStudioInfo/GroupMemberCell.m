//
//  GroupMemberCell.m
//  GuKe
//
//  Created by yb on 2020/11/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "GroupMemberCell.h"

@implementation GroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.portraitView];
        CGFloat r = IPHONE_X_SCALE(35);
        [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(r);
            make.center.equalTo(self);
        }];
        self.portraitView.clipsToBounds = YES;
        self.portraitView.layer.cornerRadius = r/2.0f;
    }
    return self;
}

- (UIImageView *)portraitView
{
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
        _portraitView.contentMode = UIViewContentModeScaleToFill;
    }
    return _portraitView;
}

@end
