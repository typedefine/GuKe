//
//  Utile.m
//  SYChuangKeProject
//
//  Created by 朱佳男 on 16/6/29.
//  Copyright © 2016年 ShangYuKeJi. All rights reserved.
//

#import "Utile.h"

@implementation Utile



+(void)addClickEvent:(id)target action:(SEL)action owner:(UIView *)view
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:gesture];
}
+(void)makeCorner:(CGFloat)corner view:(UIView *)view
{
    CALayer *layer = view.layer;
    layer.cornerRadius = corner;
    layer.masksToBounds = YES;
}
+(void)makecorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color
{
    CALayer *layer = view.layer;
    layer.borderColor = color.CGColor;
    layer.borderWidth = corner;
}
+(void)setFourSides:(UIView *)view direction:(NSString *)direction sizeW:(CGFloat)width color:(UIColor *)color
{
    if ([direction isEqualToString:@"left"]) {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, (view.frame.size.height-width)/2.0f, 0.5, width)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }else if ([direction isEqualToString:@"right"])
    {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width - 0.5, (view.frame.size.height-width)/2.0f, 0.5, width)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }else if ([direction isEqualToString:@"top"])
    {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }else if ([direction isEqualToString:@"bottom"])
    {
        UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, width, 0.5)];
        bottomview.backgroundColor = color;
        [view addSubview:bottomview];
    }
}
+(void)setUILabel:(UILabel *)label data:(NSString *)data setData:(NSString *)setData color:(UIColor *)color font:(CGFloat)font underLine:(BOOL)isbool
{
    setData = [NSString changeNullString:setData];
    NSRange range = [label.text rangeOfString:setData];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(data.length, setData.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(data.length, setData.length)];
        if (isbool) {
            [string addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(data.length, setData.length)];
        }
        label.attributedText = string;
    }
}

+(CGFloat)returnViewFrame:(UIView *)view direction:(NSString *)direction
{
    if ([direction isEqualToString:@"X"]) {
        return view.frame.origin.x+view.frame.size.width;
    }else
    {
        return view.frame.origin.y+view.frame.size.height;
    }
}
#pragma mark 判断字符是否为空
+ (BOOL)stringIsNil:(NSString *)strings{
    if ([strings isEqualToString:@""]||[strings isEqualToString:@"(null)"]||[strings isEqualToString:@"<null>"]||(strings.length == 0)||[strings isEqualToString:@"空字符"]||[strings isEqualToString:@"0"]) {
        return YES;
    }else{
        return NO;
    }
    
}
#pragma mark 判断字符是否为空
+ (BOOL)stringIsNilkong:(NSString *)strings{
    if ([strings isEqualToString:@""]||[strings isEqualToString:@"(null)"]||[strings isEqualToString:@"<null>"]||(strings.length == 0)||[strings isEqualToString:@"空字符"]) {
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark 判断字符是否为空
+ (BOOL)stringIsNilZero:(NSString *)strings{
    if ([strings isEqualToString:@""]||[strings isEqualToString:@"(null)"]||[strings isEqualToString:@"<null>"]||(strings.length == 0)) {
        return YES;
    }else{
        return NO;
    }
    
}
+ (UIImage *)imageWithMediaURL:(NSURL *)url {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    // 初始化媒体文件
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    // 根据asset构造一张图
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
    generator.appliesPreferredTrackTransform = YES;
    // 设置图片的最大size(分辨率)
    generator.maximumSize = CGSizeMake(600, 450);
    // 初始化error
    NSError *error = nil;
    // 根据时间，获得第N帧的图片
    // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 10000) actualTime:NULL error:&error];
    // 构造图片
    UIImage *image = [UIImage imageWithCGImage: img];
    NSLog(@"%@",image);
    if (!image) {
        image = [UIImage imageNamed:@"小视频占位图12"];
    }
    return image;
}
+(UIFont *)systemFontOfSize:(CGFloat)fontSize{
    
    //我是根据屏幕尺寸判断的设备，然后字体设置为0.8倍
    
    if (ScreenHeight < 568) {
        
        fontSize = fontSize * 0.8;
        
    }
    
    UIFont *newFont = [ UIFont preferredFontForTextStyle : UIFontTextStyleBody ];
    
    UIFontDescriptor *ctfFont = newFont.fontDescriptor ;
    
    NSString *fontString = [ctfFont objectForKey : @"NSFontNameAttribute"];
    
    //使用 fontWithName 设置字体
    
    return [UIFont fontWithName:fontString size:fontSize];
    
}
#pragma mark 图片翻转
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
//CommonUtil里面的类方法：
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+(NSString *)FirstCharactor:(NSString *)pString
{
    //转成了可变字符串
    NSMutableString *pStr = [NSMutableString stringWithString:pString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pPinYin = [pStr capitalizedString];
    //获取并返回首字母
    return [pPinYin substringToIndex:1];
}
+(CGSize)returnTextSizeWithText:(NSString *)text size:(CGSize)size font:(NSInteger)font{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:SetFont(font),NSFontAttributeName, nil];
    CGSize kSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return kSize;
}


@end
