//
//  WYYShiPinModel.h
//  GuKe
//
//  Created by yu on 2018/1/20.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYYShiPinModel : NSObject
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *videoContent;
@property (nonatomic,strong)NSString *videoCount;
@property (nonatomic,strong)NSString *videoId;
@property (nonatomic,strong)NSString *videoImages;
@property (nonatomic,strong)NSString *videoName;
@property (nonatomic,strong)NSString *videoPath;
@property (nonatomic,strong)NSString *videoRecommend;
@property (nonatomic,strong)NSString *videoSpeaker;
@property (nonatomic,strong)NSString *videoUnit;// 单位
@property (nonatomic,strong)NSString *videoTypeId;
@property (nonatomic,strong)NSString *videoShou; //   videoShou  1 已收藏  0 未收藏



//+(WYYShiPinModel *)makeModelWithDic:(NSDictionary *)dic;
@end
