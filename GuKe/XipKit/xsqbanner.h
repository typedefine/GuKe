//
//  xsqbanner.h
//  kongge
//
//  Created by xiaoshunliang on 16/2/1.
//  Copyright © 2016年 nil. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIImageView+WebCache.h"
typedef void(^imageClickBlock)(NSInteger index);

@interface xsqbanner : UIView
//轮播的ScrollView
@property(strong,nonatomic) UIScrollView *direct;
//轮播的页码
@property(strong,nonatomic) UIPageControl *pageVC;
//轮播滚动时间间隔
@property(assign,nonatomic) CGFloat time;
//网络加载可以选择需要使用的占为图片
@property(nonatomic,strong) NSString *placeholderName;

#pragma mark 初始化图片格式的HADirect
+(instancetype)direcWithtFrame:(CGRect)frame ImageNameArr:(NSArray *)imageNameArray AndImageClickBlock:(imageClickBlock)clickBlock;

#pragma mark 初始化自定义样式的HADirect
+(instancetype)direcWithtFrame:(CGRect)frame ViewArr:(NSArray *)customViewArr AndClickBlock:(imageClickBlock)clickBlock;
#pragma mark 设置pagecontrol 右边
-(void)MakePageFramRight;

#pragma mark 开始定时器
-(void)beginTimer;

#pragma mark 销毁定时器
-(void)stopTimer;

#pragma mark 自定义UIPageControl样式（图片大小要合适）
-(void)customPageVcWithSelectedImg:(UIImage *)selectedImg NormalImg:(UIImage *)normalImg;

@end
