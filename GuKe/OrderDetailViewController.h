//
//  OrderDetailViewController.h
//  GuKe
//
//  Created by MYMAc on 2018/8/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ realoadDataBlock)();
@interface OrderDetailViewController : BaseViewController
@property (strong ,nonatomic) NSString * urlStr;
@property (copy, nonatomic) realoadDataBlock reloadBlock;
@end
