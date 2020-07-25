//
//  ZJNShareView.m
//  GuKe
//
//  Created by 朱佳男 on 2017/11/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNShareView.h"

@implementation ZJNShareView

-(id)init{
    self = [super init];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]lastObject];
        self.shareViewHeightConstraint.constant = (ScreenWidth-120)*(18/31);
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        self.shareView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//        [self layoutIfNeeded];
        //点击背景是否隐藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (IBAction)shareToMyWeChatFriends:(id)sender {
    NSLog(@"分享到微信好友");
}
- (IBAction)shareToMyTimeLine:(id)sender {
    NSLog(@"分享到朋友圈");
}
- (IBAction)shareToMyQQFriends:(id)sender {
    NSLog(@"分享给QQ好友");
}
-(void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [UIView animateWithDuration:.3 animations:^{
//        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//        [self layoutIfNeeded];
//    }];
}
-(void)dismiss {
//    [UIView animateWithDuration:.3 animations:^{
////        self.bottomViewBottomConstraint.constant = -self.height;
//        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
//    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
