//
//  ZJNInfoView.h
//  GuKe
//
//  Created by 朱佳男 on 2018/1/3.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@protocol ZJNInfoHeaderViewDelegate<NSObject>

//将tableView偏移量传递给控制器记录下来 切换栏目的时候使用
-(void)updateContentOffSet_y:(CGFloat)y;

//
-(void)sendSearchTextToViewController:(NSString *)searchText;

@end
@interface ZJNInfoView : UIView
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic ,strong)NSMutableArray *imagePathArr;
@property (nonatomic ,weak)id<ZJNInfoHeaderViewDelegate>delegate;
@end
