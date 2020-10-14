//
//  DDCImageViewerCell.h
//  DayDayCook
//
//  Created by Christopher Wood on 11/4/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageViewerScrollView.h"
#import <Photos/Photos.h>

@interface DDCImageViewerCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) DDCImageViewerScrollView * scrollView;
@property (nonatomic, strong) UIImage                  * image;

@end
