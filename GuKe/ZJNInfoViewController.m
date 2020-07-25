//
//  ZJNInfoViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2018/1/3.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNInfoViewController.h"
#import "ZiXunDetailViewController.h"
#import "ZiXunModel.h"
#import "ZJNInfoView.h"
#import "ZJNInfoListView.h"

static CGFloat const intervalButton = 20;//顶部button之间的间隔
@interface ZJNInfoViewController ()<ZJNInfoHeaderViewDelegate,ZJNInfoListDelegate>
{

    UIButton *signButton;//记录顶部被选中的按钮
    UIScrollView *topScrollView;
    NSMutableArray *contentArray;
    CGFloat contentOffSet_y;
    ZJNInfoListView *signListView;//记录当前被选中的栏目视图
    NSString *shouStr;//轮播图收藏状态
    NSDate * comeDate;//进入模块的时间
    BOOL GetData;// YES 计算数据 NO， 不计算数据，
    
}
/** 头部资讯分类数组 */
@property (nonatomic ,strong)NSMutableArray *infoCategory;
/** 滑块儿 */
@property (nonatomic ,strong)UIView *sliderView;
/** 轮播图 */
@property (nonatomic ,strong)ZJNInfoView *infoView;
/** 容器View */
@property (nonatomic ,strong)UIView *contentView;
@end

@implementation ZJNInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    GetData = YES;

    contentOffSet_y = 0.0;
    _infoCategory = [NSMutableArray array];
    contentArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPushView:) name:@"WYYpushView" object:nil];
    
    [self.view addSubview:self.contentView];
    [self getInfoCategory];
    [self.view addSubview:self.infoView];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 轮播图页面跳转
- (void)didPushView:(NSNotification *)text{
    GetData = NO ;
//    NSLog(@"%@",text.userInfo); 没有id的话就不跳转了
    if([NSString IsNullStr:[NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"uid"]]]){
        return ;
    }
    
    ZiXunDetailViewController *detail = [[ZiXunDetailViewController alloc]init];
    detail.title = @"资讯详情";
    detail.zixunID = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"uid"]];
    detail.hidesBottomBarWhenPushed = YES;
    detail.titleStr = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"title"]];
    detail.iconImagePath = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"path"]];
    detail.contentStr = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"content"]];
    
    detail.typeStr = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"shou"]];

    detail.refershCollectStatusBlock = ^(NSString *shou) {
        
        shouStr = [NSString stringWithFormat:@"%@",shou];
        
        
    };
    
    if ([shouStr isEqualToString:@""]||(shouStr.length == 0)||[shouStr isEqualToString:@"(null)"]) {
        detail.typeStr = [NSString stringWithFormat:@"%@",[text.userInfo objectForKey:@"shou"]];
    }else{
        detail.typeStr = [NSString stringWithFormat:@"%@",shouStr];
    }
    
    
    [self.navigationController pushViewController:detail animated:NO];
    
}
-(ZJNInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[ZJNInfoView alloc]initWithFrame:CGRectMake(0, 42, ScreenWidth, lunboImgHeight+50)];
        _infoView.delegate = self;
    }
    return _infoView;
}
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    }
    return _contentView;
}
//获取资讯分类
-(void)getInfoCategory{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,informationmodule];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSLog(@"%@",sessionIding);
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"资讯列表%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            for (NSDictionary *doc in data[@"data"]) {
                ZiXunModel *model = [ZiXunModel yy_modelWithDictionary:doc];
                [self.infoCategory addObject:model];
            }
            [self creatTopScrollView];
            [self addChildView];
        }
    } failure:^(NSError *error) {
        NSLog(@"资讯列表%@",error);
    }];
}
#pragma mark-- 创建顶部分类
-(void)creatTopScrollView{
    topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    topScrollView.backgroundColor = [UIColor whiteColor];
    [topScrollView addSubview:self.sliderView];
    CGFloat beginX = 20;
    for (int i = 0; i <self.infoCategory.count; i ++) {
        ZiXunModel *model = self.infoCategory[i];
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
        CGFloat buttonWidth = [model.typeName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(beginX, 0, buttonWidth, 40);
        beginX += (intervalButton+buttonWidth);
        
        [button setTitleColor:titColor forState:UIControlStateNormal];
        [button setTitleColor:greenC forState:UIControlStateSelected];
        [button setTitle:[NSString stringWithFormat:@"%@",model.typeName] forState:UIControlStateNormal];
        button.tag = 10 +i;
        button.titleLabel.font =Font14;
        
        [button addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [topScrollView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            signButton = button;
            self.sliderView.frame = CGRectMake(intervalButton/2.0, 40, buttonWidth+intervalButton, 2);
        }
    }
    topScrollView.contentOffset = CGPointMake(0, 0);
    topScrollView.contentSize = CGSizeMake(beginX, 0);
    [self.view addSubview:topScrollView];
}
#pragma mark--添加子视图
-(void)addChildView{
    for (int i = 0; i <self.infoCategory.count; i ++) {

        ZJNInfoListView *view = [[ZJNInfoListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
        view.delegate = self;
        view.model = self.infoCategory[i];
        [contentArray addObject:view];
        
        if (i == 0) {
            signListView = view;
            [self.contentView addSubview:view];
            self.infoView.tableView = view.tableView;
        }
    }
}

#pragma mark-- 创建滑块儿
-(UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc]init];
        _sliderView.backgroundColor = greenC;
    }
    return _sliderView;
}
#pragma mark-- 顶部按钮点击实现方法
-(void)categoryButtonClick:(UIButton *)button{
    signButton.selected = NO;
    button.selected = YES;
    signButton = button;
    NSInteger index = button.tag-10;

    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ZJNInfoListView *view = contentArray[index];
    view.tableView.contentOffset = CGPointMake(0, contentOffSet_y);
    [self.contentView addSubview:view];
    self.infoView.tableView = view.tableView;
    signListView = view;
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderView.frame = CGRectMake(button.x-intervalButton/2.0, 40,button.width+intervalButton, 2);
    }];
    
}
#pragma mark--ZJNInfoHeaderViewDelegate
-(void)updateContentOffSet_y:(CGFloat)y{
    contentOffSet_y = y;
}
-(void)sendSearchTextToViewController:(NSString *)searchText{
    if (!searchText.length) {
        [self showHint:@"请输入搜索内容"];
        return;
    }
    signListView.searchText = searchText;
}
#pragma mark--ZJNInfoListDelegate
-(void)updateListWithState:(NSString *)state{
    if ([state isEqualToString:@"1"]) {
        [self showHudInView:self.view hint:nil];
    }else{
        [self hideHud];
    }
}
-(void)pushToDetailInfoWithModel:(ZiXunlistModel *)model{
    GetData = NO ;
    ZiXunDetailViewController *detail = [[ZiXunDetailViewController alloc]init];
    detail.title = @"资讯详情";
    detail.zixunID = [NSString stringWithFormat:@"%@",model.uid];
    detail.hidesBottomBarWhenPushed = YES;
    detail.titleStr = model.title;
    detail.iconImagePath = model.image;
    detail.contentStr = model.content;
    detail.typeStr = model.shou;
    detail.refershCollectStatusBlock = ^(NSString *shou) {
            model.shou = shou;
        };
    [self.navigationController pushViewController:detail animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (GetData) {
        comeDate =[NSDate date];

    }
    GetData = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    if (GetData) {
        [moduleDate ShareModuleDate].IformationLength =[[NSDate date]timeIntervalSinceDate:comeDate];
    }

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
