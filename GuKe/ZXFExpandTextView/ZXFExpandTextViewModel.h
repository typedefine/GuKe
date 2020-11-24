//
//  ZXFExpandTextViewModel.h
//  GuKe
//
//  Created by yb on 2020/11/9.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXFExpandTextViewModel : NSObject

@property (nonatomic, assign) NSInteger constractTextMaxLength;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSUInteger lineNumForContraction;
//@property (nonatomic, assign) float lineHeight;//default is 20
//@property (nonatomic, assign) float maxWidth;//default is screenWidth -20*20
//@property (nonatomic, strong) UIFont *font;//default is 15
//@property (nonatomic, strong) UIColor *textColor;//default is #3C3E3D
//@property (nonatomic, strong) UIColor *tintColor;//default is greenC

@end

NS_ASSUME_NONNULL_END
