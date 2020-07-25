//
//  mineCollectView.m
//  GuKe
//
//  Created by MYMAc on 2018/3/23.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "mineCollectView.h"

@implementation mineCollectView{
    
    UIButton * leftBtn ;
    UIButton * rightBtn;
    UIView* linView;
//     两个button 一个 线
}

-(instancetype)init{
   
    if (self = [super init]) {
        [self makeUI];
    }
    
    return  self;
}
-(void)makeUI{
    leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"资讯" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [leftBtn setTitleColor:greenC forState:UIControlStateSelected];
    leftBtn.tag = 21;
    leftBtn.selected = YES;
    [self addSubview:leftBtn];
    rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rightBtn];
    rightBtn.tag =22;
    
    rightBtn.selected = NO;
    [rightBtn setTitle:@"视频" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [rightBtn setTitleColor:greenC forState:UIControlStateSelected];

    
    linView =[[UIView alloc]init];
    linView.backgroundColor = greenC;
    [self addSubview:linView];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.bottom.mas_equalTo(linView.top);
        make.width.mas_equalTo(self).width.multipliedBy(0.5);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.top.mas_equalTo(self.right);
        make.bottom.mas_equalTo(linView.top);
        make.width.mas_equalTo(leftBtn.mas_width);

    }];
    
    [linView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(self).multipliedBy(0.5);
        make.left.mas_equalTo(self);
    }];
    
    [leftBtn addTarget:self action:@selector(BtnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(BtnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)BtnSelectAction:(UIButton*)seleBtn;{
    
    leftBtn.selected = NO;
    rightBtn.selected =NO;
//    if (seleBtn.tag ==21) {// 选中 资讯
//
//    }else{// 选中 视频
//
//    }
    [self layoutIfNeeded];

    seleBtn.selected = YES;
    [linView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(self).multipliedBy(0.5);
        make.left.mas_equalTo(seleBtn.mas_left);
    }];
    
 
     if ([self.delegate respondsToSelector:@selector(selectItemWithIndex:)]) {

        [self.delegate selectItemWithIndex:seleBtn.tag - 21];
    }
    
}
-(void)makeSelectItemWihtIndex:(NSInteger)index{
    leftBtn.selected = NO;
    rightBtn.selected =NO;
    UIButton * button  = (UIButton *)[self viewWithTag:21+index];
    button.selected = YES;
    [linView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(self).multipliedBy(0.5);
        make.left.mas_equalTo(button.mas_left);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
