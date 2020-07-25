//
//  WYYShiPinDetailViewController.h
//  GuKe
//
//  Created by yu on 2018/1/23.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WYYShiPinDetailViewController : UIViewController
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *contentStr;
@property (nonatomic,strong)NSString *iconImagePath;

@property (nonatomic,strong)NSString *videoId;//热门视频主键
@property (nonatomic,strong)NSString *videoShou;//是否收藏
@property (nonatomic,assign)BOOL  CanSaveDate;//是否采集时长  首页过来的采集其他的不采集


@property(nonatomic,strong)void(^refershCollectStatusBlock)(NSString *CollectStatu);
@end
