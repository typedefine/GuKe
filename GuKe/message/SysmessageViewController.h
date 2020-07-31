//
//  SysmessageViewController.h
//  GuKe
//
//  Created by MYMAc on 2019/3/19.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SysmessageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView * _TV;
    NSMutableArray * dataArray ;
}

@end

NS_ASSUME_NONNULL_END
