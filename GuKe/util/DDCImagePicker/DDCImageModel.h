//
//  DDCImageModel.h
//  DayDayCook
//
//  Created by Christopher Wood on 11/6/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import <Photos/Photos.h>

@interface DDCImageModel : NSObject

//+(instancetype)modelWithImage:(UIImage*)image asset:(PHAsset*)asset tag:(NSString*)tag;

@property (nonatomic, strong) UIImage  * image;
@property (nonatomic, strong) PHAsset  * asset;
@property (nonatomic, assign) NSInteger tag;
//@property (nonatomic, assign) BOOL       isCompletedDownload;
@property (nonatomic) CGSize             maxSize;

@property (nonatomic, assign) BOOL       isSelected;

@end
