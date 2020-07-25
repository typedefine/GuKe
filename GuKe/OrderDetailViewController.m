//
//  OrderDetailViewController.m
//  GuKe
//
//  Created by MYMAc on 2018/8/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "OrderDetailViewController.h"
#import <WebKit/WebKit.h>
#import <AlipaySDK/AlipaySDK.h>
@interface OrderDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *webviews;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"pay"];
    [configuration.userContentController addScriptMessageHandler:self name:@"alipay"];
    [configuration.userContentController addScriptMessageHandler:self name:@"save"];

     self.webviews = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) configuration:configuration];
    self.webviews.UIDelegate = self;
    self.webviews.navigationDelegate = self;
    [self.view addSubview:self.webviews];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];

//    NSURL *url = [NSURL URLWithString:@"http://115.28.220.220:8080/bone/app/pay/pay.json?orderNumber=20180809123456792"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webviews loadRequest:request];
    // Do any additional setup after loading the view.
//     支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WEPAYSUCCESS:) name:@"WXPAYSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AIRPAYSUCCESS:) name:@"AIRSUCCESS" object:nil];
  
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
   
    if ([message.name isEqualToString:@"pay"]) {
        //     微信
        [self weixinZhifu:message.body];
    }else if([message.name isEqualToString:@"alipay"]){
        //     支付宝
        [self AliPay:message.body];
        
    }else if ([message.name isEqualToString:@"save"]){
        
        [self AlertWithMessage:message.body];
    }
    
    
}
-(void)AlertWithMessage:(NSString *)message{
    
   
    UIAlertController  * al =[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * sureact =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * _Nonnull action) {
        if(self.reloadBlock){
            self.reloadBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];
    
    [al addAction:sureact];
    [self presentViewController:al animated:YES completion:nil];
    
}
// /app/order/pay.json

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL relativePath];
    NSLog(@" host = %@ query=%@ relativePath= %@",[URL host],[URL query],[URL relativePath]);
    if ([scheme containsString:@"/app/order/pay.json"] && ![[URL query] containsString:@"sessionId"]) {
        
        NSString * payUrl =[NSString stringWithFormat:@"%@%@?sessionId=%@",requestUrl,[URL relativePath],sessionIding];
        
        
        NSURL *url = [NSURL URLWithString:payUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webviews loadRequest:request];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// APP调用h5
-(void)hellacton{

    [self.webviews evaluateJavaScript:@"alipayForPhone('IOS')" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"alipayForPhone(IOS)");
    }];
    [self.webviews evaluateJavaScript:@"wxpayForPhone('IOS')" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"alipayForPhone(IOS)");
    }];
 

}

  // 支付宝支付
-(void)AliPay:(NSString *)signedString{
    if (signedString != nil) {
         //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"BoneProject";
      
          // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]] caseInsensitiveCompare:@"9000"] == NSOrderedSame) {
//支付成
            }
        }];
    }
}

-(void)weixinZhifu:(NSDictionary *)dict{

    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"appid"];
        if (retcode.length > 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.partnerId = [dict objectForKey:@"partnerid"];// 商家ID
            req.prepayId            = [dict objectForKey:@"prepayid"];// 订单号
            req.nonceStr = [dict objectForKey:@"noncestr"]; /** 随机串，防重发 */
            req.timeStamp = stamp.intValue;/** 时间戳，防重发 */
            req.package    = [dict objectForKey:@"package"];/** 商家根据财付通文档填写的数据和签名 */
            req.sign                = [dict objectForKey:@"sign"];/** 商家根据微信开放平台文档对数据做的签名 */
            BOOL Result  = [WXApi sendReq:req];
            NSLog(@"-- %d",Result);
            
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            //                NSLog([dict objectForKey:@"retmsg"])";
        }
    }else{
        NSLog(@"服务器返回错误，未获取到json对象");
    }}

//支付宝 成功
-(void)AIRPAYSUCCESS:(NSNotification *)center{
    
    NSDictionary   * resultDic = (NSDictionary*)center.object;
   
    
    if ([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]] caseInsensitiveCompare:@"9000"] == NSOrderedSame) {
        if(self.reloadBlock){
            self.reloadBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
        //         成功
    }else{
        [self showHint:@"支付失败"];
    }
    
}
//微信 成功
-(void)WEPAYSUCCESS:(NSNotification *)center{
    BaseResp  * baseResp = (BaseResp*)center.object;
    if (baseResp.errCode ==0) {
        if(self.reloadBlock){
            self.reloadBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];

        //        [self Paysuccess];
    }else if (baseResp.errCode ==-1){
                [self showHint:@"支付失败"];
    }else{
        //        [self showHint:@"您已取消支付"];
    }
   
    
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
