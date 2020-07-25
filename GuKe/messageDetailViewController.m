//
//  messageDetailViewController.m
//  GuKe
//
//  Created by MYMAc on 2019/3/19.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "messageDetailViewController.h"
#import "UIWebView+DKProgress.h"

@interface messageDetailViewController ()<UIWebViewDelegate>{
    UIWebView * web;
}

@end

@implementation messageDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.WebTitle;
    self.view.backgroundColor =[UIColor whiteColor];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    self.webUrl = @"https:www.baidu.com";
    web =[[UIWebView alloc]initWithFrame:CGRectMake(0, 4, ScreenWidth, ScreenHeight -4)];
    web.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    web.dk_progressLayer.progressColor = greenC;
    web.dk_progressLayer.progressStyle = _style;
    
    [self.view.layer addSublayer:web.dk_progressLayer];
    //    [self.navigationController.navigationBar.layer addSublayer:web.dk_progressLayer];
    //
    web.delegate =self;
 
     NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.webUrl]]];
    [web loadRequest:request];
    [self.view addSubview:web];
    
}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked){
//        NSString *url = [request.URL absoluteString];
//        //        //拦截链接跳转
//        //    http://www.huirongfa.com/share.com   分享
//        //    http://www.huirongfa.com/detail.com   明细
//        if ([url isEqualToString:@"http://www.huirongfa.com/share.com"]){
//            NSLog(@"分享");
//            [self shareInfor];
//            return NO;
//        }else if([url isEqualToString:@"http://www.huirongfa.com/detail.com"]){
//            self.webUrl = [NSString stringWithFormat:@"http://www.huirongfa.com/Wap/Public/detail/uid/%@.html",UserId];
//            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.webUrl]]];
//            [web loadRequest:request];
//            return  NO;
//        }
//    }
//    return YES;
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//-(void)shareInfor{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    //创建网页内容对象
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"汇融法－法律服务平台" descr:@"欢迎使用汇融法，成功注册可领取现金红包 ！" thumImage:[UIImage imageNamed:@"login_logo"]];
//    //设置网页地址
//    shareObject.webpageUrl = [NSString stringWithFormat:@"http://www.huirongfa.com/Wap/Public/register/uid/%@.html",UserId];
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//    }];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
