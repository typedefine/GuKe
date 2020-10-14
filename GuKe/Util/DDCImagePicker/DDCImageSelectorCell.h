//
//  DDCImageSelectorCell.h
//  DayDayCook
//
//  Created by Christopher Wood on 11/3/16.
//  Copyright © 2016 GFeng. All rights reserved.
//


@class DDCImageModel;

@interface DDCImageSelectorCell : UICollectionViewCell

- (void)configureCellWithData:(DDCImageModel *)data
                     itemSize:(CGSize)itemSize
                selectedBlock:(void (^)(DDCImageModel *imageModel, UIButton *button))selectedBlock;

- (void)configureCellForCamera;

@end
