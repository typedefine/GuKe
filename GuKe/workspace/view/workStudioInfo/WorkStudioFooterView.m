//
//  WorkGroupFooterView.m
//  GuKe
//
//  Created by yb on 2020/11/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkStudioFooterView.h"


@implementation WorkStudioFooterView


- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect f = self.membersView.frame;
    f.origin.y += f.size.height + IPHONE_Y_SCALE(20);
    f.size.height = IPHONE_Y_SCALE(100);
    self.supporterView.frame = f;
    [self addSubview:self.supporterView];
//    [self.supporterView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.right.equalTo(self).offset(-20);
//        make.bottom.equalTo(self).offset(-IPHONE_Y_SCALE(20));
//        make.height.mas_equalTo(IPHONE_Y_SCALE(100));
//    }];
    
    [self addSubview:self.membersView];
//    [self.membersview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(IPHONE_Y_SCALE(20));
//        make.left.right.equalTo(self.supporterView);
//        make.bottom.equalTo(self.supporterView.mas_top).offset(-IPHONE_Y_SCALE(30));
////        make.height.mas_equalTo(IPHONE_Y_SCALE(150));
//    }];
   
}


- (GroupMembersView *)membersView
{
    if (!_membersView) {
        _membersView = [[GroupMembersView alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth-40, IPHONE_Y_SCALE(130))];
    }
    return _membersView;
}

- (WorkStudioSupporterView *)supporterView
{
    if (!_supporterView) {
        _supporterView = [[WorkStudioSupporterView alloc] init];
    }
    return _supporterView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
