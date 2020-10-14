//
//  DDCImageViewerController.h
//  DayDayCook
//
//  Created by Christopher Wood on 11/4/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "BaseViewController.h"
@class DDCImageModel;

@interface DDCImageViewerController : BaseViewController

@property (nonatomic, strong)NSArray<DDCImageModel *> * albumImageAssetArray;

@property (nonatomic)NSInteger currentIndex;

@end
