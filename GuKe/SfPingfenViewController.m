//
//  SfPingfenViewController.m
//  GuKe
//
//  Created by yu on 2017/9/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SfPingfenViewController.h"
#import <WebKit/WebKit.h>

@interface SfPingfenViewController ()<WKUIDelegate,WKNavigationDelegate>{
    WKWebView *harrWek;
}


@end

@implementation SfPingfenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SF-12评分";
    harrWek = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    harrWek.UIDelegate = self;
    harrWek.navigationDelegate = self;
    [self.view addSubview:harrWek];
    
    NSString *urlString;
    if ([self.valStr isEqualToString:@"(null)"]||[self.valStr isEqualToString:@""]||[self.valStr isEqualToString:@"<null>"]||(self.valStr == nil)) {
        urlString = [NSString stringWithFormat:@"%@/app/sf/list.json",requestUrl];
    }else{
        urlString = [NSString stringWithFormat:@"%@/app/sf/list.json?val=%@&pfuid=%@",requestUrl,self.valStr,self.pfuid];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [harrWek loadRequest:request];

    // Do any additional setup after loading the view from its nib.
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *str = navigationAction.request.URL.absoluteString;
    
    
    if ([str rangeOfString:@"harris/val.json?val"].location != NSNotFound) {
        //
        NSString *urlString = [NSString stringWithFormat:@"%@",str];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
            NSLog(@"%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                NSDictionary *sfValueDic = data[@"data"];
                if (self.returnValueSfBlock) {
                    self.returnValueSfBlock(sfValueDic);
                }
                [self.navigationController popViewControllerAnimated:NO];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"%@",error);
        }];
        //
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
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
