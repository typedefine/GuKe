//
//  DDCFullScreenImageSelector.h
//  DayDayCook
//
//  Created by Christopher Wood on 11/3/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageViewerController.h"
#import <Photos/Photos.h>
#import "DDCImageModel.h"
#import "BaseViewController.h"

@protocol DDCFullScreenImageSelectorDelegate;

@interface DDCImageSelectorCachePolicy : NSObject

@property (nonatomic, copy) NSString *reuseId;

@property (nonatomic, assign) NSInteger limit;

- (instancetype)initWithReuseId:(NSString *)ID limit:(NSInteger)limit;

@end

@interface DDCFullScreenImageSelector : BaseViewController

@property (nonatomic, assign ) NSInteger limitCount; //default is 1.

-(instancetype)initWithDelegate:(id<DDCFullScreenImageSelectorDelegate>)delegate;
- (void)show;
- (void)dismiss;
- (void)deleteWithCacheImageList:(NSArray<DDCImageModel *> *)cacheImageList;

@property (nonatomic, strong) NSArray<DDCImageSelectorCachePolicy *> *selectionCachePolicyList;

-(instancetype)initWithDelegate:(id<DDCFullScreenImageSelectorDelegate>)delegate selectionCachePolicyList:(NSArray<DDCImageSelectorCachePolicy *> *)selectionCachePolicyList;
- (void)showWithCache:(DDCImageSelectorCachePolicy *)cache;


@end

@protocol DDCFullScreenImageSelectorDelegate <NSObject>
@optional

/**
 *  点击确定的回调
 *
 *  @param assetArray 选中的照片的url数组
 */
- (void)imageSelector:(DDCFullScreenImageSelector *)imgSelector didSelectWithImageList:(NSArray<DDCImageModel *> *)imageList;

/**
 *  点击任何一张图片的回调
 *
 *  @param asset 点击照片的asset，可通过asset拿到图片(缩略图，高清图，全屏图)和路径
 *  @param index 点击照片所在的位置
 */
//- (void)imageSelector:(DDCFullScreenImageSelector *)imgSelector everyImageClick:(PHAsset *)asset index:(NSInteger)index;

/**
 *  点击取消的回调
 *
 */
-(void)cancelClickForImageSelector:(DDCFullScreenImageSelector *)imgSelector;

@end
