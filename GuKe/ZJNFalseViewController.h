//
//  ZJNFalseViewController.h
//  GuKe
//
//  Created by 朱佳男 on 2017/10/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 创建这个控制器的原因是，在我们自动登录的时候可能我的启动页已经加载完成了 但是我的登录接口请求还没有完成，如果这时候不加处理的话 会导致有在接口请求尚未成功而启动页已经加载完成的情况下有一个时间段展示出来的是白屏的效果。
 
 这里 我们在控制器上创建一个imageView 显示跟启动页相同的图片 在启动页加载完成后我们将此控制器设置为rootViewController  而当我们的登录接口请求完成之后 我们再将rootViewController换成我们的主页面
 */
@interface ZJNFalseViewController : UIViewController

@end
