//
//  WYYeMenShiPinViewController.m
//  GuKe
//
//  Created by yu on 2018/1/19.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYeMenShiPinViewController.h"
#import "WYYShipinViewController.h"
#import "WYYShiPinModel.h"
#import "OrderTypeModel.h"
#define  SavePathStr  @"Newsid.plist"
@interface WYYeMenShiPinViewController ()<UIScrollViewDelegate>{
    CGFloat SpaceofButton;// button 之间的间距
    
    NSMutableArray *typeArr;//分类数组
    NSMutableArray * allcategoaryArray;// 全部的分类
    UIButton *signButton;//标记点击的按钮
    CGFloat heights;
}
// 头部的标签scroll
@property (nonatomic, strong) UIScrollView *segmentScrollView;
//黄色的线条
@property (nonatomic, strong) UIImageView  *currentSelectedItemImageView;
// 展示view的Scroll
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@end

@implementation WYYeMenShiPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门视频";
    self.view.backgroundColor = [UIColor whiteColor];
    typeArr = [NSMutableArray array];
    allcategoaryArray = [NSMutableArray array];
    SpaceofButton = 20;
    if (IS_IPGONE_X) {
        heights = 106 + 64;
    }else{
        heights = 106;
    }
    [self makeTypeArray];
    // Do any additional setup after loading the view.
}
#pragma mark 视频分类
- (void)makeTypeArray{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,pubvideolisttype];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"视频分类%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *arrayOne = [NSArray arrayWithArray:data[@"data"]];
            for (NSDictionary *dica in arrayOne) {
                OrderTypeModel *model = [OrderTypeModel yy_modelWithJSON:dica];
                [typeArr addObject:model];
                [allcategoaryArray addObject:model];
            }
           
        }
        NSLog(@"%@",typeArr);
        [self getcateData];
    } failure:^(NSError *error) {
        NSLog(@"视频分类%@",error);
    }];
}
- (UIScrollView *)bottomScrollView {
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,41, ScreenWidth, ScreenHeight-41)];
        _bottomScrollView.delegate = self;
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.scrollEnabled = YES;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.bounces = NO;
        for (int i = 0; i<typeArr.count; i++) {
            OrderTypeModel *model = typeArr[i];
            WYYShipinViewController *view = 
            [[WYYShipinViewController alloc]init];
            view.model = model;
            view.view.frame = CGRectMake(i *ScreenWidth, 0, ScreenWidth, ScreenHeight-41);
            [self addChildViewController:view];
            [self.bottomScrollView addSubview:view.view];
        }
        
        /*
         添加viewController
         */
        self.bottomScrollView.contentSize = CGSizeMake(typeArr.count * ScreenWidth, 0);
    }
    return _bottomScrollView;
}
-(void)updatabottomScrollView{
    
    for (WYYShipinViewController * viwe in self.childViewControllers) {
        [viwe removeFromParentViewController];
    }
    
    for (int i = 0; i<typeArr.count; i++) {
        OrderTypeModel *model = typeArr[i];
        WYYShipinViewController *view = [[WYYShipinViewController alloc]init];
        view.model = model;
        view.view.frame = CGRectMake(i *ScreenWidth,0, ScreenWidth, ScreenHeight-41);
        [self addChildViewController:view];
        [self.bottomScrollView addSubview:view.view];
    }
    self.bottomScrollView.contentOffset = CGPointMake(0, 0);
    
    self.bottomScrollView.contentSize = CGSizeMake(typeArr.count * ScreenWidth, 0);
    
}
-(void)getcateData{
    [typeArr removeAllObjects];
    [typeArr addObjectsFromArray:[self getNewsidDataFromPlist]];
    
    if (typeArr.count == 0 && allcategoaryArray.count  <10) {
        // 本地没存储 切分类不超过十个  全部显示
        [typeArr addObjectsFromArray:allcategoaryArray];
        
        [self  saveCountToFile];
        
    } else  if (typeArr.count == 0 && allcategoaryArray.count   >= 10) {
        for (int i = 0 ;i< 10 ; i++) {
            [typeArr addObject:allcategoaryArray[i]];
        }
        [self  saveCountToFile];
        
    }
    if(_segmentScrollView){// 存在的话更新
        [self updatasegmentScrollView];
        [self updatabottomScrollView];
        
    }else{ // 不存在 加载
        [self.view addSubview:self.segmentScrollView];
        [self.view addSubview:self.bottomScrollView];
        
    }
    
    
}
-(void)updatasegmentScrollView{
    [_segmentScrollView removeFromSuperview];
    [_segmentScrollView addSubview:self.currentSelectedItemImageView];
    CGFloat beginX = 20; //  每个button的起始 x 值  button 之间相差 20  px
    for (int i = 0; i <typeArr.count; i ++) {
        OrderTypeModel *model = typeArr[i];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
        CGFloat Width =  [model.typeName boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(beginX , 0, Width, 39);
        button.backgroundColor = [UIColor orangeColor];
        beginX += (SpaceofButton+Width);
        
        
        [button setTitleColor:SetColor(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:SetColor(0x0BCF9E) forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%@",model.typeName] forState:UIControlStateNormal];
        button.tag = 10 +i;
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        
        
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentScrollView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            signButton = button;
            _currentSelectedItemImageView.frame = CGRectMake(button.x, 40, Width, 2);
        }
    }
    _segmentScrollView.contentOffset = CGPointMake(0, 0);
    _segmentScrollView.contentSize = CGSizeMake(beginX, 0);
    
}
- (UIScrollView *)segmentScrollView {
    
    if (!_segmentScrollView) {
        [_segmentScrollView removeFromSuperview];
        _segmentScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 41)];
        [_segmentScrollView addSubview:self.currentSelectedItemImageView];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor whiteColor];
        CGFloat beginX = 20;
        for (int i = 0; i <typeArr.count; i ++) {
            OrderTypeModel *model = typeArr[i];
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            CGFloat Width =   [model.typeName boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(beginX , 0, Width, 39);
            beginX += (SpaceofButton+Width);
            [button setTitleColor:SetColor(0x333333) forState:UIControlStateNormal];
            [button setTitleColor:SetColor(0x0BCF9E) forState:UIControlStateSelected];
            [button setTitle:[NSString stringWithFormat:@"%@",model.typeName] forState:UIControlStateNormal];
            button.tag = 10 +i;
            button.titleLabel.font =[UIFont systemFontOfSize:14];
            
            [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentScrollView addSubview:button];
            if (i == 0) {
                button.selected = YES;
                signButton = button;
                _currentSelectedItemImageView.frame = CGRectMake(button.x, 40, Width, 2);
            }
        }
        _segmentScrollView.contentSize = CGSizeMake(beginX , 0);
    }
    return _segmentScrollView;
    
}

//黄色滑块
- (UIImageView *)currentSelectedItemImageView {
    if (!_currentSelectedItemImageView) {
        _currentSelectedItemImageView = [[UIImageView alloc] init];
        _currentSelectedItemImageView.backgroundColor = SetColor(0x0BCF9E);
    }
    return _currentSelectedItemImageView;
}
//分类按钮点击实现方法
-(void)categoryButtonClick:(UIButton *)button{
    signButton.selected = NO;
    button.selected = YES;
    signButton = button;
    NSInteger index = button.tag-10;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(index*ScreenWidth, 0);
        
        self.currentSelectedItemImageView.frame = CGRectMake(button.x, 40,button.width, 2);
        
    }];
    
}

// 获取 选中的类型
- (NSArray *)getNewsidDataFromPlist{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:SavePathStr];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
}
// 第一次 选前实施条信息 存起来
- (void)saveCountToFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:SavePathStr];
    [NSKeyedArchiver archiveRootObject:typeArr toFile:filePath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    UIButton *button = (UIButton *)[self.view viewWithTag:10+index];
    signButton.selected = NO;
    button.selected = YES;
    signButton = button;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(index*ScreenWidth, 0);
        
        self.currentSelectedItemImageView.frame = CGRectMake(button.x-SpaceofButton/2, 40,button.width+SpaceofButton, 2);
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
