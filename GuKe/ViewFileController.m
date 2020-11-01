//
//  ViewFileWebController.m
//  GuKe
//
//  Created by yb on 2020/10/18.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ViewFileController.h"

@interface ViewFileController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *fileWeb;

@end

@implementation ViewFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backanniu"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    self.title = self.fileUrl.absoluteString.lastPathComponent;
    
    [self.view addSubview:self.fileWeb];
    
    [self.fileWeb loadRequest:[NSURLRequest requestWithURL:self.fileUrl]];
}

//返回按钮点击实现方法
-(void)backButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (UIWebView *)fileWeb
{
    if (!_fileWeb) {
        _fileWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [_fileWeb sizeToFit];
        _fileWeb.delegate = self;
        _fileWeb.scalesPageToFit = YES;
//        [self.view addSubview:_fileWeb];
    }
    return _fileWeb;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
//    NSString *javascript = [NSString stringWithFormat:@"var script = document.createElement('script');"
//                            "script.type = 'text/javascript';"
//                            "script.text = \"function ResizeImages() { "
//                            "var myimg;"
//                            "var maxwidth=%f;" //缩放系数
//                            "for(i=0;i <document.images.length;i++){"
//                            "myimg = document.images[i];"
//                            "if(myimg.width > maxwidth){"
//                            "var scale = myimg.width/myimg.height;"
//                            "myimg.width = maxwidth;"
//                            "myimg.height = maxwidth/scale;"
//                            "}"
//                            "}"
//                            "}\";"
//                            "document.getElementsByTagName('head')[0].appendChild(script);",CGRectGetWidth(webView.frame)];
//    [webView stringByEvaluatingJavaScriptFromString:javascript];
//
//    //添加调用JS执行的语句
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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
