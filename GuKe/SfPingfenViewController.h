//
//  SfPingfenViewController.h
//  GuKe
//
//  Created by yu on 2017/9/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueSfBlock) (NSDictionary *sfValueDic);
@interface SfPingfenViewController : UIViewController
@property(nonatomic, copy) ReturnValueSfBlock returnValueSfBlock;
@property (nonatomic,strong)NSString *valStr;//评分分数;
@property (nonatomic,strong)NSString *pfuid;//评分选项;
@end
