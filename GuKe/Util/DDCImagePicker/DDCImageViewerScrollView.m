//
//  DDCImageViewerScrollView.m
//  DayDayCook
//
//  Created by Christopher Wood on 11/4/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageViewerScrollView.h"

@interface DDCImageViewerScrollView()

@end

@implementation DDCImageViewerScrollView

-(void)setChildView:(UIView *)childView
{
    [_childView removeFromSuperview];
    _childView = childView;
    [self addSubview:_childView];
    
    [self setContentOffset:CGPointZero];
}


@end
