//
//  ZJNInfoListView.h
//  GuKe
//
//  Created by 朱佳男 on 2018/1/3.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiXunModel.h"
#import "ZiXunlistModel.h"
@protocol ZJNInfoListDelegate<NSObject>

/**
 由于当前页面架构无法正常展示下拉刷新 所以这里写了一个代理方法 当下拉刷新的时候调用

 @param state 1 开始请求数据  2 请求数据结束
 */
-(void)updateListWithState:(NSString *)state;
//点击单元格实现跳转
-(void)pushToDetailInfoWithModel:(ZiXunlistModel *)model;
@end
@interface ZJNInfoListView : UIView
@property (nonatomic ,strong)NSString *searchText;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)ZiXunModel *model;
@property (nonatomic ,weak)id<ZJNInfoListDelegate>delegate;
@end
