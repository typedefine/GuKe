//
//  WYYMainTableViewCell.h
//  GuKe
//
//  Created by yu on 2018/1/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYYMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *SearchView;
@property (copy, nonatomic) void(^searchBlock)();


@end
