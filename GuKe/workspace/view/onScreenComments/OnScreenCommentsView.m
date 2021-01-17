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
#import "DMItemView.h"

@interface OnScreenCommentsView ()<FDanmakuViewProtocol>
@property(nonatomic,weak)FDanmakuView *danmakuView;
@property(nonatomic, assign) NSInteger itemTime;
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
    self.itemTime = 0;
    FDanmakuView *danmaView = [[FDanmakuView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 30)];
    danmaView.backgroundColor = [UIColor clearColor];
    danmaView.delegate = self;
    self.danmakuView = danmaView;
    [self addSubview:danmaView];
}

- (void)configWithType:(NSInteger)type conttent:(NSString *)content sendUser:(UserInfoModel *)user
{
    DMModel *model = [[DMModel alloc] init];
    model.doctorName = user.doctorName;
    model.content = content;
    model.msgType = type;
    FDanmakuModel *viewModel = [[FDanmakuModel alloc]init];
    viewModel.model = model;
    viewModel.beginTime = 0;
    viewModel.liveTime = 3;
    [self.danmakuView.modelsArr insertObject:viewModel atIndex:0];
}

- (void)configWithData:(id)data
{
    [self.danmakuView.modelsArr removeAllObjects];
    NSArray *dataList = (NSArray *)data;
    NSMutableArray<FDanmakuModel *> *targetArray = [NSMutableArray array];
    for (int i=0; i< dataList.count ;i++) {
        NSDictionary *d = dataList[i];
        DMModel *model = [DMModel mj_objectWithKeyValues:d];
        FDanmakuModel *viewModel = [[FDanmakuModel alloc]init];
        viewModel.model = model;
        self.itemTime += 1 + arc4random()%4;
        viewModel.beginTime = self.itemTime;
        viewModel.liveTime = 2 + arc4random()%3;
        [targetArray addObject:viewModel];
    }
    
    [self.danmakuView.modelsArr addObjectsFromArray:targetArray];
    
    /*
    FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
    model1.name = @"2df";
    model1.type = 0;
    model1.beginTime = 1;
    model1.liveTime = 3;
    model1.content = @"哈哈哈~😊🙂😎~~~";

    FDanmakuModel *model2 = [[FDanmakuModel alloc]init];
    model2.name = @"Jack";
    model2.type = 1;
    model2.beginTime = 2.2;
    model2.liveTime = 3;
    model2.content = @"23322333";
    
    FDanmakuModel *model3 = [[FDanmakuModel alloc]init];
    model3.name = @"占永青";
    model3.type = 2;
    model3.beginTime = 3.8;
    model3.liveTime = 3;
    model3.content = @"https:bghgdhs.com/";
    
    [self.danmakuView.modelsArr addObject:model1];
    [self.danmakuView.modelsArr addObject:model2];
    [self.danmakuView.modelsArr addObject:model3];
   */
}

-(NSTimeInterval)currentTime {
    static double time = 0;
    time += 0.1;
    return time;
}

- (UIView *)danmakuViewWithModel:(FDanmakuModel*)model
{
    DMItemView *itemView = [[DMItemView alloc] init];
    [itemView configWithData:model];
//    UILabel *label = [UILabel new];
//    label.text = model.content;
//    [label sizeToFit];
    return itemView;
    
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


- (void)clean
{
    [self.danmakuView.modelsArr removeAllObjects];
}
@end
