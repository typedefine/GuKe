//
//  WorkGroupTitleView.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupTitleView.h"

@interface WorkGroupTitleView ()

@property (nonatomic, strong) UIButton *addWorkSpaceBtn;

@end

@implementation WorkGroupTitleView


- (void)setUp
{
    [super setUp];
    
    [self addSubview:self.addWorkSpaceBtn];
    [self.addWorkSpaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-20);
    }];
    [self.addWorkSpaceBtn addTarget:self action:@selector(addWorkSpace) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addWorkSpace
{
    if (self.action) {
        self.action();
    }
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    
    if (subTitle != nil) {
        [self.addWorkSpaceBtn setTitle:subTitle forState:UIControlStateNormal];
    }
}

- (UIButton *)addWorkSpaceBtn
{
    if (!_addWorkSpaceBtn) {
        _addWorkSpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addWorkSpaceBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_addWorkSpaceBtn setTitleColor:greenC forState:UIControlStateNormal];
    }
    return _addWorkSpaceBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
