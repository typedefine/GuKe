//
//  PhotoChoseView.m
//  GuKe
//
//  Created by yu on 2017/8/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "PhotoChoseView.h"

@implementation PhotoChoseView

+ (id)makeAddButton{
    return [[self alloc] initWithFrame:CGRectZero];
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 100)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 8;
        [self addSubview:backView];
        
        _ButtonOne = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 49)];
        [_ButtonOne setTitle:@"从相册选择" forState:normal];
        [_ButtonOne setTitleColor:SetColor(0xf3b100) forState:normal];
        [_ButtonOne addTarget:self action:@selector(SelectBtnOne) forControlEvents:UIControlEventTouchUpInside];
        _ButtonOne.titleLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:_ButtonOne];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, ScreenWidth - 20, 1)];
        lineView.backgroundColor = SetColor(0xf0f0f0);
        [backView addSubview:lineView];
        
        _ButtonTwo = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth - 20, 50)];
        [_ButtonTwo setTitle:@"拍照" forState:normal];
        [_ButtonTwo setTitleColor:greenC forState:normal];
        [_ButtonTwo addTarget:self action:@selector(SelectBtnTwo) forControlEvents:UIControlEventTouchUpInside];
        _ButtonTwo.titleLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:_ButtonTwo];
        
        _ButtonThree = [[UIButton alloc]initWithFrame:CGRectMake(10, 110, ScreenWidth - 20, 50)];
        _ButtonThree.backgroundColor = [UIColor whiteColor];
        _ButtonThree.layer.masksToBounds = YES;
        _ButtonThree.layer.cornerRadius = 8;
        [_ButtonThree setTitle:@"取消" forState:normal];
        [_ButtonThree setTitleColor:greenC forState:normal];
        [_ButtonThree addTarget:self action:@selector(SelectBtnThree) forControlEvents:UIControlEventTouchUpInside];
        _ButtonThree.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_ButtonThree];
        
        
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (void)SelectBtnOne{
    [self.delegate makeSelectBtnOne];
}
- (void)SelectBtnTwo{
    [self.delegate makeSelectBtnTwo];
}
- (void)SelectBtnThree{
    [self.delegate makeSelectBtnThree];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
