//
//  harrisPingfenViewController.m
//  GuKe
//
//  Created by yu on 2017/9/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "harrisPingfenViewController.h"
#import <WebKit/WebKit.h>
@interface harrisPingfenViewController ()<WKUIDelegate,WKNavigationDelegate>{
    WKWebView *harrWek;
}

@end

@implementation harrisPingfenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.formName;
    harrWek = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    harrWek.UIDelegate = self;
    harrWek.navigationDelegate = self;
    [self.view addSubview:harrWek];
    
    NSString *urlString;
    // 没有评分的时候
    if ([self.saveNumber isEqualToString:@"(null)"]||[self.saveNumber isEqualToString:@""]||[self.saveNumber isEqualToString:@"<null>"]||(self.saveNumber == nil)) {
        urlString = [NSString stringWithFormat:@"%@/app/pubsave/appLook.json?formId=%@",requestUrl,self.formId];
    }else{
        urlString = [NSString stringWithFormat:@"%@/app/pubsave/appLook.json?formId=%@&saveNumber=%@&saveColumn=%@",requestUrl,self.formId,self.saveNumber,self.saveColumn];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [harrWek loadRequest:request];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *str = navigationAction.request.URL.absoluteString;

    
    if ([str rangeOfString:@"app/pubsave/val.json?"].location != NSNotFound) {
        //
        NSString *urlString = [NSString stringWithFormat:@"%@",str];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
            
            NSLog(@"%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0"]) {
                NSDictionary *valueDic = data[@"data"];
                if (self.returnValueBlock) {
                    self.returnValueBlock(valueDic);
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
