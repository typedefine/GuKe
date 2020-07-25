//
//  HssPingfenViewController.h
//  GuKe
//
//  Created by yu on 2017/9/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueHsBlock) (NSDictionary *hssDic);
@interface HssPingfenViewController : UIViewController
@property(nonatomic, copy) ReturnValueHsBlock returnValueHsBlock;
@property (nonatomic,strong)NSString *valStr;//评分分数;
@property (nonatomic,strong)NSString *pfuid;//评分选项;
@end
