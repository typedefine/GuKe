//
//  H9ViewController.m
//  GuKe
//
//  Created by MYMAc on 2018/8/9.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "H9ViewController.h"
#import <WebKit/WebKit.h>
@interface H9ViewController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation H9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webviews = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44)];
    webviews.UIDelegate = self;
    webviews.navigationDelegate = self;
    [self.view addSubview:webviews];
    
    //    NSString *urlString = [NSString stringWithFormat:@"%@/app/information/show.json?uid=%@",requestUrl,self.orderNumber];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webviews loadRequest:request];
    // Do any additional setup after loading the view.
    UIButton * baomingbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [baomingbtn setTitle:@"报名参会" forState:UIControlStateNormal];
    [baomingbtn setBackgroundColor:[UIColor colorWithHex:0x287EF9]];
    [self.view addSubview:baomingbtn];
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
