//
//  ZJNSignUpMeetingIntroduceTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/11/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNSignUpMeetingIntroduceTableViewCell.h"
#import <WebKit/WebKit.h>

@interface ZJNSignUpMeetingIntroduceTableViewCell()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>
{
    UIView *bgView;
}
@property(nonatomic,strong)UIWebView *webview;
@property(nonatomic,strong)WKWebView *WKWebview;
@end
static CGFloat staticheight = 0;
@implementation ZJNSignUpMeetingIntroduceTableViewCell
+(CGFloat)cellHeight
{
    return 8+staticheight;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.webview];
//        [self.contentView addSubview:self.WKWebview];
    }
    return self;
    
}

-(void)setHtmlString:(NSString *)htmlString
{
    _htmlString = htmlString;
    self.webview.delegate = self;
    [self.webview loadHTMLString:htmlString baseURL:nil];
//    [self.WKWebview loadHTMLString:htmlString baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+20 ;
    self.webview.frame = CGRectMake(8, 0, ScreenWidth-16, height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.webview.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.webview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.webview.layer.mask = maskLayer;
//    self.webview.hidden = NO;
    if (staticheight != height+1) {
        
        staticheight = height+1;
        
        if (staticheight > 0) {
            
            if (_reloadBlock) {
                _reloadBlock();
            }
        }
    }
}
-(UIWebView *)webview
{
    if (!_webview) {
        _webview =[[UIWebView alloc]initWithFrame:CGRectMake(8, 0, ScreenWidth-16, 20)];
//        _webview.userInteractionEnabled = NO;
//        self.webview.mediaPlaybackRequiresUserAction=NO

//        _webview.hidden = YES;
    }
    return _webview;
}
-(WKWebView *)WKWebview{
    if(!_WKWebview){
    _WKWebview = [[WKWebView alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth-16, 20)];
    _WKWebview.navigationDelegate = self;
    _WKWebview.UIDelegate = self;
    //开了支持滑动返回
    _WKWebview.allowsBackForwardNavigationGestures = YES;
    }
    return  _WKWebview;
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    
      [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        
         NSLog(@"scrollHeight高度：%.2f",[result floatValue]);
    
    CGFloat height = [result floatValue]+20 ;
    self.WKWebview.frame = CGRectMake(8, 0, ScreenWidth-16, height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.WKWebview.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.WKWebview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.WKWebview.layer.mask = maskLayer;
    //    self.webview.hidden = NO;
    if (staticheight != height+1) {
        
        staticheight = height+1;
        
        if (staticheight > 0) {
            
            if (_reloadBlock) {
                _reloadBlock();
            }
        }
    }
        
    }];

        
 }
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
