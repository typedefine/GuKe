//
//  ZJNOperationTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationInfoModel.h"
@interface ZJNOperationTableViewCell : UITableViewCell<UIScrollViewDelegate>
//医生姓名
@property (nonatomic ,strong)UILabel * doctorNameLabel;
//手术时间
@property (nonatomic ,strong)UILabel * operationTimeLabel;
//麻醉方式
@property (nonatomic ,strong)UILabel * typeLabel;
//手术入路
@property (nonatomic ,strong)UILabel * approachLabel;
//手术名字
@property (nonatomic ,strong)UILabel * operationNameLabel;
//器材品牌
@property (nonatomic ,strong)UILabel * brandLabel;
//器械品牌的scroller 
@property (nonatomic ,strong)UIScrollView *scrol;
//第一助手
@property (nonatomic ,strong)UILabel * firstLabel;
//第二助手
@property (nonatomic ,strong)UILabel * secondLabel;
//手术类别
@property (nonatomic ,strong)UILabel * surgeryTypeLabel;
@property (nonatomic ,strong)OperationInfoModel *model;
@end
