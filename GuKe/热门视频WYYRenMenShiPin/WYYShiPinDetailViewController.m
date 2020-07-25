//
//  WYYShiPinDetailViewController.m
//  GuKe
//
//  Created by yu on 2018/1/23.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WYYShiPinDetailViewController.h"
#import <WebKit/WebKit.h>
@interface WYYShiPinDetailViewController ()<WKUIDelegate,WKNavigationDelegate>{
    UIImageView *sanJiaoView;
    UIImageView *whiteView;
    UIView *heiseView;
    NSDate * comeDate;//进入模块的时间

}

@end

@implementation WYYShiPinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频详情";
    comeDate =[NSDate date];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *TwoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MORE"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedTwoView)];
    self.navigationItem.rightBarButtonItem = TwoBarItem;
    
    [self makeAddView];
    // Do any additional setup after loading the view.
}
- (void)onClickedTwoView{
    heiseView.hidden = NO;
}

- (void)makeAddView{
    WKWebView *webviews = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    webviews.UIDelegate = self;
    webviews.navigationDelegate = self;
    [self.view addSubview:webviews];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?videoId=%@&sessionId=%@",requestUrl,pubvideolook,self.videoId,sessionIding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webviews loadRequest:request];
    
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.contentStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSLog(@"%@",attributedString);
//
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [[[UIApplication sharedApplication]keyWindow] addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    
    whiteView  = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 74, 140, 176 )];
    whiteView.userInteractionEnabled = YES;
    whiteView.image = [UIImage imageNamed:@"分享背景"];
    [heiseView addSubview:whiteView];
    
    
    NSArray *imgArr= [NSArray arrayWithObjects:@"分享-微信-好友2",@"分享-微-朋友圈-",@"分享-站内好友",@"分享-收藏", nil];
    
    NSArray *nameArr;
    
    if ([self.videoShou isEqualToString:@"1"]) {
        nameArr = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"QQ",@"取消收藏", nil];
    }else{
        nameArr = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"QQ",@"收藏", nil];
    }
    
    for (int a = 0; a < 4; a ++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12 + 44*a, 20, 20)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[a]]];
        [whiteView addSubview:img];
        
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+ 5, 12 + 44*a, 100, 20)];
        labels.font = [UIFont systemFontOfSize:16];
        labels.textColor = titColor;
        labels.tag = a;
        labels.text = [NSString stringWithFormat:@"%@",nameArr[a]];
        [whiteView addSubview:labels];
        
        UIView *lineVew = [[UIView alloc]initWithFrame:CGRectMake(10,44 + 44*a, 120, 1)];
        lineVew.backgroundColor = SetColor(0xf0f0f0);
        [whiteView addSubview:lineVew];
        if (a == 3) {
            lineVew.hidden = YES;
        }
        
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0, 10 + 0 + 44*a, 140, 44)];
        btns.tag = 10 + a;
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btns];
    }
    
    [self.view bringSubviewToFront:heiseView];
}
- (void)didButton:(UIButton *)sender{
    if (sender.tag == 10) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if (sender.tag == 11){
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }else if (sender.tag == 12){
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }else{
         [self makeCollection];
     }
}
#pragma mark 添加我的收藏  // 已收藏的会取消收藏，未收藏的收藏
- (void)makeCollection{
    heiseView.hidden = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,collectionadd];
    NSArray *keysArray = @[@"sessionid",@"videoid"];
    NSArray *valueArray = @[sessionIding,self.videoId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"添加我的收藏%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSDictionary *shouDic = data[@"data"];
            NSString *shouStr = shouDic[@"shou"];
            //shoustr 0 未收藏  1 已收藏
            UILabel *collectLabel = (UILabel *)[heiseView viewWithTag:3];
            if ([shouStr isEqualToString:@"1"]) {
                collectLabel.text = @"取消收藏";
            }else{
                collectLabel.text = @"收藏";
            }
            if (self.refershCollectStatusBlock) {
                self.refershCollectStatusBlock(shouStr);
            }
        }else{
            
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"收藏失败！"];
        NSLog(@"添加我的收藏%@",error);
    }];
}
-(void)setRefershCollectStatusBlock:(void (^)(NSString *))refershCollectStatusBlock{
    _refershCollectStatusBlock =[refershCollectStatusBlock copy];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  [NSString stringWithFormat:@"%@%@",imgPath,self.iconImagePath];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:self.contentStr thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@?videoId=%@",requestUrl,pubvideofxlook,self.videoId];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
     
}
#pragma mark wkwebview
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self showHudInView:self.view hint:nil];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideHud];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self showHint:@"加载失败!"];
    [self hideHud];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}
- (void)didViewBlockView{
    heiseView.hidden =YES;
    // whiteView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)navigationShouldPopOnBackButton{
//   从首页进来的要进行统计  
    if (self.CanSaveDate) {
        [moduleDate ShareModuleDate].ShipinLength =[[NSDate date]timeIntervalSinceDate:comeDate];
    }
    
    return  YES ;
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
