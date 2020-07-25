//
//  ZJNChoosePicturesTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJNChoosePicturesTableViewCell;
@protocol ZJNChoosePCellDelegate<NSObject>
@required
/*
 * 添加图片
 */
-(void)choosePicturesTableViewCellAddPicturesWithCell:(ZJNChoosePicturesTableViewCell *)cell;
/*
 * 预览图片
 */
-(void)choosePicturesTableViewCellPreviewPictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell;
/*
 * 删除图片
 */
-(void)choosePicturesTableViewCellDeletePictureWithIndex:(NSInteger)index withCell:(ZJNChoosePicturesTableViewCell *)cell;

@end

@interface ZJNChoosePicturesTableViewCell : UITableViewCell

@property (nonatomic ,strong)NSArray *imageArray;

@property (nonatomic ,weak)id<ZJNChoosePCellDelegate>delegate;

@property (nonatomic ,strong)UIView *bgView;
@end
