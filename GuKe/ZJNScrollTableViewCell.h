//
//  ZJNScrollTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNScrollTableViewCell : UITableViewCell
@property (nonatomic ,strong)NSArray      *typeArray;
@property (nonatomic ,strong)UILabel      *titleLabel;
@property (nonatomic ,strong)UIScrollView *scrollView;
@end
