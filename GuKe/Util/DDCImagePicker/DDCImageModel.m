//
//  DDCImageModel.m
//  DayDayCook
//
//  Created by Christopher Wood on 11/6/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageModel.h"

@implementation DDCImageModel

//+(instancetype)modelWithImage:(UIImage*)image asset:(PHAsset*)asset tag:(NSString*)tag
//{
//    DDCImageModel * model = [[DDCImageModel alloc] init];
//    model.image = image;
//    model.asset = asset;
//    model.tag = tag;
//    model.isCompletedDownload = (image != nil);
//    
//    return model;
//}

-(CGSize)maxSize
{
//    CGFloat max = self.asset.pixelWidth > self.asset.pixelHeight ? self.asset.pixelHeight : self.asset.pixelWidth;
//    return CGSizeMake(max, max);
    return CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
}

@end
