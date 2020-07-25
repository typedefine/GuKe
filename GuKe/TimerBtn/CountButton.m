//
//  CountButton.m
//  kechematou
//
//  Created by Ymm on 15/7/28.
//  Copyright (c) 2015年 kechematou. All rights reserved.
//

#import "CountButton.h"
//#import "Addtion.h"

@implementation CountButton

+ (CountButton *)countButtonWith:(SEL)method WithTarget:(id)target
{
    CountButton *button = [CountButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)startTime{
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithHex:0x3181FE] forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //  int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"(%.2d)后重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [self setTitle:strTime forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithHex:0xc6c6c6] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeout--;
            if (timeout == 1) {
                self.userInteractionEnabled = YES;
                [self setTitleColor:[UIColor colorWithHex:0x007AFF] forState:UIControlStateNormal];

            }
            
        }
    });
    dispatch_resume(_timer);
}

-(void)WXstartTime{
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self setBackgroundColor:[UIColor colorWithHex:0xcccccc]];
                [self setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //  int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"(%.2d)后重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //                NSLog(@"____%@",strTime);
                [self setTitle:strTime forState:UIControlStateNormal];
                [self setBackgroundColor:[UIColor colorWithHex:0xf9f9f9]];
                [self setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeout--;
            if (timeout == 1) {
                self.userInteractionEnabled = YES;
                [self setTitleColor:[UIColor colorWithHex:0x007AFF] forState:UIControlStateNormal];
                
            }
            
        }
    });
    dispatch_resume(_timer);
}


@end
