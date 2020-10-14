//
//  UIImageView+CornerRadius.m
//  TSC_Dashboard
//
//  Created by tsc on 2018/5/17.
//  Copyright © 2018年 TSC. All rights reserved.
//

#import "UIImageView+CornerRadius.h"
#import <objc/runtime.h>

const char kProcessedImage;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat zyRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) CGFloat zyBorderWidth;
@property (strong, nonatomic) UIColor *zyBorderColor;
@property (assign, nonatomic) BOOL zyHadAddObserver;
@property (assign, nonatomic) BOOL zyIsRounding;

@end





@implementation UIImageView (CornerRadius)
/**
 * @brief init the Rounding UIImageView, no off-screen-rendered
 */
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self zy_cornerRadiusRoundingRect];
    }
    return self;
}

/**
 * @brief init the UIImageView with cornerRadius, no off-screen-rendered
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self zy_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

/**
 * @brief attach border for UIImageView with width & color
 */
- (void)zy_attachBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.zyBorderWidth = width;
    self.zyBorderColor = color;
}

#pragma mark - Kernel
/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (void)zy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief clip the cornerRadius with image, draw the backgroundColor you want, UIImageView must be setFrame before, no off-screen-rendered, no Color Blended layers
 */
- (void)zy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    [self drawBorder:cornerPath];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (processedImage) {
        objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for UIImageView, no off-screen-rendered
 */
- (void)zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.zyRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.zyIsRounding = NO;
    if (!self.zyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.zyHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

/**
 * @brief become Rounding UIImageView, no off-screen-rendered
 */
- (void)zy_cornerRadiusRoundingRect {
    self.zyIsRounding = YES;
    if (!self.zyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.zyHadAddObserver = YES;
    }
    //Xcode 8 xib 删除了控件的Frame信息，需要主动创造
    [self layoutIfNeeded];
}

#pragma mark - Private
- (void)drawBorder:(UIBezierPath *)path {
    if (0 != self.zyBorderWidth && nil != self.zyBorderColor) {
        [path setLineWidth:2 * self.zyBorderWidth];
        [self.zyBorderColor setStroke];
        [path stroke];
    }
}

- (void)zy_dealloc {
    if (self.zyHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self zy_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(zy_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(zy_LayoutSubviews)];
    });
}

- (void)zy_LayoutSubviews {
    [self zy_LayoutSubviews];
    if (self.zyIsRounding) {
        [self zy_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.zyRadius && 0 != self.roundingCorners && nil != self.image) {
        [self zy_cornerRadiusWithImage:self.image cornerRadius:self.zyRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.zyIsRounding) {
            [self zy_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.zyRadius && 0 != self.roundingCorners && nil != self.image) {
            [self zy_cornerRadiusWithImage:newImage cornerRadius:self.zyRadius rectCornerType:self.roundingCorners];
        }
    }
}

#pragma mark property
- (CGFloat)zyBorderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setZyBorderWidth:(CGFloat)zyBorderWidth {
    objc_setAssociatedObject(self, @selector(zyBorderWidth), @(zyBorderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zyBorderColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZyBorderColor:(UIColor *)zyBorderColor {
    objc_setAssociatedObject(self, @selector(zyBorderColor), zyBorderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zyHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZyHadAddObserver:(BOOL)zyHadAddObserver {
    objc_setAssociatedObject(self, @selector(zyHadAddObserver), @(zyHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zyIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZyIsRounding:(BOOL)zyIsRounding {
    objc_setAssociatedObject(self, @selector(zyIsRounding), @(zyIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zyRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setZyRadius:(CGFloat)zyRadius {
    objc_setAssociatedObject(self, @selector(zyRadius), @(zyRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}





- (UIImageView *)CreateImageViewWithFrame:(CGRect)rect
                            andBackground:(CGColorRef)color
                                andRadius:(CGFloat)radius{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();   // 设置上下文
    CGContextSetLineWidth(context, 1);                  // 边框大小
    CGContextSetStrokeColorWithColor(context, color);   // 边框颜色
    CGContextSetFillColorWithColor(context, color);     // 填充颜色

    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGContextMoveToPoint(context, x+width, y+radius/2);
    CGContextAddArcToPoint(context, x+width, y+height, x+width-radius/2, y+height, radius);
    CGContextAddArcToPoint(context, x, y+height, x, y+height-radius/2, radius);
    CGContextAddArcToPoint(context, x, y, x+radius/2, y, radius);
    CGContextAddArcToPoint(context, x+width, y, x+width, y+radius/2, radius);
    CGContextDrawPath(context, kCGPathFillStroke);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageView;
}

//- (void)
//{
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    //设置大小
//    maskLayer.frame = imageView.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    imageView.layer.mask = maskLayer;
//
//}

@end
