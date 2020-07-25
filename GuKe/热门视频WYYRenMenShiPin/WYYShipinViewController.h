//
//  WYYShipinViewController.h
//  GuKe
//
//  Created by yu on 2018/1/19.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTypeModel.h"
@interface WYYShipinViewController : UIViewController
@property (nonatomic,strong)UITableView *orderTable;
@property (nonatomic,strong)OrderTypeModel *model;
@end
