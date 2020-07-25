//
//  ZJNInfoView.m
//  GuKe
//
//  Created by 朱佳男 on 2018/1/3.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNInfoView.h"
#import "ZiXunDetailViewController.h"
@interface ZJNInfoView()<SDCycleScrollViewDelegate,UITextFieldDelegate>
{
    UIView *view;//搜索框的背景视图
    NSString *searchText;//搜索内容
    NSArray *lunboArray;//轮播图
}
@end
@implementation ZJNInfoView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        searchText = @"";
        _imagePathArr = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        // 网络加载 --- 创建带标题的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,ScreenWidth,lunboImgHeight) delegate:self placeholderImage:[UIImage imageNamed:@"bannerImage"]];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        
        [self addSubview:_cycleScrollView];
        
        
        //背景
        view = [[UIView alloc]initWithFrame:CGRectMake(0, self.cycleScrollView.bottom, ScreenWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        //搜索框
        UIView *bGView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 30)];
        bGView.backgroundColor = SetColor(0xeae9e9);
        bGView.layer.masksToBounds = YES;
        bGView.layer.cornerRadius = 15;
        [view addSubview:bGView];
        
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        images.image = [UIImage imageNamed:@"搜索-搜索"];
        [bGView addSubview:images];
        
        UITextField *searchText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(images.frame) + 5, 0, bGView.width-50, 30)];
        searchText.placeholder = @"搜资讯";
        searchText.font = Font12;
        searchText.textColor = SetColor(0xb3b3b3);
        searchText.delegate = self;
        [bGView addSubview:searchText];
        
        UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70, 10, 70, 30)];
        searchButton.titleLabel.font = Font12;
        [searchButton setTitle:@"搜索" forState:normal];
        [searchButton setTitleColor:titColor forState:normal];
        [searchButton addTarget:self action:@selector(didSouSuoButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:searchButton];
        
        [self makeLunbotu];
        
        
    }
    return self;
}
#pragma mark 轮播图展示
- (void)makeLunbotu{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,carouselcarouselimg];
    NSArray *keysArray = @[@"sessionid",@"biztype"];
    NSArray *valueArray = @[sessionIding,@"12"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"轮播图展示%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            lunboArray = [NSArray arrayWithArray:data[@"data"]];
            for (NSDictionary *dica in lunboArray) {
                NSString *urlStrs = [NSString stringWithFormat:@"%@%@",imgPath,[dica objectForKey:@"path"]];
                [self.imagePathArr addObject:urlStrs];
            }
            _cycleScrollView.imageURLStringsGroup = self.imagePathArr;
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"轮播图展示%@",error);
    }];
}
-(void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew;
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}
#pragma mark--

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    UITableView *tableView = (UITableView *)object;
    CGFloat tableViewOffsetY = tableView.contentOffset.y;
    if (tableViewOffsetY>0) {
        self.frame = CGRectMake(0, 42, ScreenWidth, lunboImgHeight+50);
        
        self.cycleScrollView.frame = CGRectMake(0, 0, ScreenWidth, lunboImgHeight);
        view.frame = CGRectMake(0, self.cycleScrollView.bottom, ScreenWidth, 50);
        if (tableViewOffsetY < lunboImgHeight) {
            self.frame = CGRectMake(0, -tableViewOffsetY+42, ScreenWidth, lunboImgHeight+50);
        }else{
            self.frame = CGRectMake(0, -lunboImgHeight+42, ScreenWidth, lunboImgHeight+50);
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(updateContentOffSet_y:)]) {
            if (tableViewOffsetY<lunboImgHeight) {
                [self.delegate updateContentOffSet_y:tableViewOffsetY];
            }else{
                [self.delegate updateContentOffSet_y:lunboImgHeight];
            }
        }
    }else{

        //注释掉的代码可以实现下拉后轮播图变大的效果
//        self.frame = CGRectMake(0, 42, ScreenWidth, lunboImgHeight+50-tableViewOffsetY);
//        self.cycleScrollView.frame = CGRectMake(0, 0, ScreenWidth, lunboImgHeight-tableViewOffsetY);
        self.frame = CGRectMake(0, 42, ScreenWidth, lunboImgHeight+50);
        self.cycleScrollView.frame = CGRectMake(0, 0, ScreenWidth, lunboImgHeight);
        view.frame = CGRectMake(0, self.cycleScrollView.bottom, ScreenWidth, 50);
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateContentOffSet_y:)]) {
            [self.delegate updateContentOffSet_y:0.0];
        }
    }
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    ZiXunDetailViewController *detail = [[ZiXunDetailViewController alloc]init];
    detail.title = @"资讯详情";
    detail.zixunID = [NSString stringWithFormat:@"%@",lunboArray[index][@""]];
    detail.hidesBottomBarWhenPushed = YES;
    detail.titleStr = [NSString stringWithFormat:@"%@",lunboArray[index][@""]];;
    detail.iconImagePath = [NSString stringWithFormat:@"%@",lunboArray[index][@"imgname"]];;
    detail.contentStr = [NSString stringWithFormat:@"%@",lunboArray[index][@"content"]];;
    detail.typeStr = [NSString stringWithFormat:@"%@",lunboArray[index][@"shou"]];
    
    NSDictionary *dica = [NSDictionary dictionaryWithDictionary:lunboArray[index]];
    
    //创建通知
    
    NSNotification *notification =[NSNotification notificationWithName:@"WYYpushView" object:nil userInfo:dica];
    
    //通过通知中心发送通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
#pragma mark--输入框代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    searchText = textField.text;
}
#pragma mark--点击搜索按钮点击实现方法
-(void)didSouSuoButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendSearchTextToViewController:)]) {
        [self.delegate sendSearchTextToViewController:searchText];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
