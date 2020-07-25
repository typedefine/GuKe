//
//  H5ViewController.m
//  GuKe
//
//  Created by MYMAc on 2018/8/9.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "H5ViewController.h"
#import <WebKit/WebKit.h>

@interface H5ViewController()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webviews = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    webviews.UIDelegate = self;
    webviews.navigationDelegate = self;
    [self.view addSubview:webviews];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webviews loadRequest:request];
    // Do any additional setup after loading the view.
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
