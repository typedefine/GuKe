//
//  TitleAndImageViewTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TitleAndImageViewTableViewCell;
@protocol titleAndImageViewTableViewCellDelegate<NSObject>

-(void)showImageWithIndex:(NSInteger)index withCell:(TitleAndImageViewTableViewCell *)cell;
@end
@interface TitleAndImageViewTableViewCell : UITableViewCell
@property (nonatomic ,strong)NSArray *imageArray;
@property (nonatomic ,strong)UIView  *bgView;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,weak)id<titleAndImageViewTableViewCellDelegate>delegate;
@end

