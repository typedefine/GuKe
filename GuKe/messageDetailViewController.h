//
//  messageDetailViewController.h
//  GuKe
//
//  Created by MYMAc on 2019/3/19.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKProgressLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface messageDetailViewController : UIViewController
@property(nonatomic, assign) DKProgressStyle style;
@property (strong, nonatomic) NSString * WebTitle;// 默认是协议
@property (strong, nonatomic) NSString * webUrl;// 默认是协议


@end

NS_ASSUME_NONNULL_END
