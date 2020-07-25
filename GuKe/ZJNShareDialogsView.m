//
//  ZJNShareDialogsView.m
//  GuKe
//
//  Created by 朱佳男 on 2017/11/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNShareDialogsView.h"
#define dislogsViewWidth ScreenWidth-120
#define dislogsViewHeight 0.58*dislogsViewWidth
@implementation ZJNShareDialogsView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        //点击背景是否隐藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    UIView *dialogsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth-60, 0.58*(ScreenWidth-60))];
    dialogsView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [Utile makeCorner:5 view:dialogsView];
    dialogsView.center = self.center;
    dialogsView.userInteractionEnabled = YES;
    [self addSubview:dialogsView];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 44)];
    shareLabel.text = @"分享";
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [dialogsView addSubview:shareLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth-60, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:233/255.0 alpha:1];
    [dialogsView addSubview:lineView];
    
    CGFloat buttonWidth;
    if (IS_IPHONE_5) {
        buttonWidth = (ScreenWidth-60-132)/4.0;
    }else{
        buttonWidth = (ScreenWidth-60-150)/4.0;
    }
    
    NSArray *buttonImageArray = @[@"微信",@"朋友圈",@"qq"];
    NSArray *shareTypeArray = @[@"微信好友",@"朋友圈",@"QQ"];
    for (int i = 0; i <3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE_5) {
            button.frame = CGRectMake(buttonWidth+i*(buttonWidth+44), CGRectGetMaxY(lineView.frame)+15, 44, 44);
        }else{
            button.frame = CGRectMake(buttonWidth+i*(buttonWidth+50), CGRectGetMaxY(lineView.frame)+30, 50, 50);
        }
        [button setBackgroundImage:[UIImage imageNamed:buttonImageArray[i]] forState:UIControlStateNormal];
        button.tag = 10+i;
        [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [dialogsView addSubview:button];
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(button.frame)-10, CGRectGetMaxY(button.frame)+4, CGRectGetWidth(button.frame)+20, 20)];
        typeLabel.font = [UIFont systemFontOfSize:12];
        typeLabel.text = shareTypeArray[i];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        [dialogsView addSubview:typeLabel];
    }
}
-(void)shareButtonClick:(UIButton *)button{
    if (button.tag == 10) {
        NSLog(@"分享给微信好友");
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if (button.tag == 11){
        NSLog(@"分享到朋友圈");
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }else{
        NSLog(@"分享到QQ");
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"骨先生" descr:@"骨科医生的贴心小助手,每天五分钟，轻松管理患者" thumImage:[UIImage imageNamed:@"80"]];
    //设置网页地址
    shareObject.webpageUrl = @"https://itunes.apple.com/cn/app/%E9%AA%A8%E5%85%88%E7%94%9F/id1306407596?mt=8";
    
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
-(void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)dismiss {
    
    [self removeFromSuperview];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
