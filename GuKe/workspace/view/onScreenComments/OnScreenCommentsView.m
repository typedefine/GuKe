//
//  OnScreenCommentsView.m
//  GuKe
//
//  Created by yb on 2021/1/7.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "OnScreenCommentsView.h"
#import "FDanmakuView.h"
#import "FDanmakuModel.h"

@interface OnScreenCommentsView ()<FDanmakuViewProtocol>
@property(nonatomic,weak)FDanmakuView *danmakuView;
@end

@implementation OnScreenCommentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    FDanmakuView *danmaView = [[FDanmakuView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 25)];
    danmaView.backgroundColor = [UIColor clearColor];
    danmaView.delegate = self;
    self.danmakuView = danmaView;
    [self addSubview:danmaView];
}

- (void)configWithData:(id)data
{
    FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
    model1.beginTime = 3;
    model1.liveTime = 5;
    model1.content = @"哈哈哈~😊🙂😎~~~";
    
    FDanmakuModel *model2 = [[FDanmakuModel alloc]init];
    model2.beginTime = 3.2;
    model2.liveTime = 8;
    model2.content = @"23322333";
    
    [self.danmakuView.modelsArr addObject:model1];
    [self.danmakuView.modelsArr addObject:model2];
}

-(NSTimeInterval)currentTime {
    static double time = 0;
    time += 0.1 ;
    return time;
}

- (UIView *)danmakuViewWithModel:(FDanmakuModel*)model {
    
    UILabel *label = [UILabel new];
    label.text = model.content;
    [label sizeToFit];
    return label;
    
}

- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point {
    NSLog(@"%@ %@",danmuView,NSStringFromCGPoint(point));
}

- (void)pause
{
    [self.danmakuView pause];
}

- (void)resume
{
    [self.danmakuView resume];
}


@end
