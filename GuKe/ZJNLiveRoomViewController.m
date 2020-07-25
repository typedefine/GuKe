//
//  ZJNLiveRoomViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/11/2.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNLiveRoomViewController.h"
#import <WebKit/WebKit.h>
@interface ZJNLiveRoomViewController ()<WKNavigationDelegate,WKUIDelegate>{
    UIImageView *whiteView;
    UIView *heiseView;
    WKWebView *detailWeb;
    
}

@end

@implementation ZJNLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.title = @"直播间";
    UIBarButtonItem *TwoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MORE"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedTwoView)];
    self.navigationItem.rightBarButtonItem = TwoBarItem;
    
    
    [self makeAddView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)onClickedTwoView{
    heiseView.hidden = NO;
}

- (void)didButton:(UIButton *)sender{
    if (sender.tag == 10) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if (sender.tag == 11){
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    else if (sender.tag == 12){
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }else{
        [self makeCollection];
    }
    
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = [NSString stringWithFormat:@"%@%@",imgPath,self.shareImagePath];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:self.concent thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@?roomId=%@",requestUrl,fxliveroom,self.huiyiID];
    
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
- (void)makeAddView{
    
    
    detailWeb = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    detailWeb.UIDelegate = self;
    detailWeb.navigationDelegate = self;


    NSString *urlString;
    if([self.isBack isEqualToString:@"1"]){
        urlString  = [NSString stringWithFormat:@"%@%@?meetingid=%@",requestUrl,Backroom,self.huiyiID];

    }else{
        urlString  = [NSString stringWithFormat:@"%@%@?roomId=%@",requestUrl,liveroom,self.huiyiID];

    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [detailWeb loadRequest:request];
    [self.view addSubview:detailWeb];
    
    
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [[[UIApplication sharedApplication]keyWindow] addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    
    whiteView  = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 54, 140, 132)];
    whiteView.userInteractionEnabled = YES;
    whiteView.image = [UIImage imageNamed:@"分享背景"];
    [heiseView addSubview:whiteView];
    
    
    NSArray *imgArr= [NSArray arrayWithObjects:@"分享-微信-好友2",@"分享-微-朋友圈-",@"分享-站内好友",@"分享-收藏", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"QQ",@"收藏", nil];
    for (int a = 0; a < 3; a ++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12 + 44*a, 20, 20)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[a]]];
        [whiteView addSubview:img];
        
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+ 5, 12 + 44*a, 100, 20)];
        labels.font = [UIFont systemFontOfSize:16];
        labels.tag = 100+a;
        labels.textColor = titColor;
        labels.text = [NSString stringWithFormat:@"%@",nameArr[a]];
        [whiteView addSubview:labels];
        
        UIView *lineVew = [[UIView alloc]initWithFrame:CGRectMake(10,44 + 44*a, 120, 1)];
        lineVew.backgroundColor = SetColor(0xf0f0f0);
        [whiteView addSubview:lineVew];
        if (a == 2) {
            lineVew.hidden = YES;
        }
        
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0, 10 + 0 + 44*a, 140, 44)];
        btns.tag = 10 + a;
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btns];
        
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
  
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }else{
        if ([URL.absoluteString containsString:@"http"]) {
            //注意，这里要取消action，否则会在原界面加载url
//            decisionHandler(WKNavigationActionPolicyCancel);
//            手动跳转至新界面加载url
        }
    }
    
        decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark 添加我的收藏
- (void)makeCollection{
    heiseView.hidden = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,collectionadd];
    NSArray *keysArray = @[@"sessionid",@"meetingid"];
    NSArray *valueArray = @[sessionIding,self.huiyiID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"添加我的收藏%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        UILabel *titleLabel = (UILabel *)[whiteView viewWithTag:103];
        titleLabel.text = @"取消收藏";
        if ([retcode isEqualToString:@"0"]) {
            
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
/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)didViewBlockView{
    heiseView.hidden =YES;
    // whiteView.hidden = YES;
}

#pragma mark - WKNavigationDelegate
 // 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self showHudInView:self.view hint:nil];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideHud];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
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
