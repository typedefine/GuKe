//
//  harrisPingfenViewController.h
//  GuKe
//
//  Created by yu on 2017/9/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnValueHarrisBlock) (NSDictionary *harrisDic);
@interface harrisPingfenViewController : UIViewController

@property(nonatomic, copy) ReturnValueHarrisBlock returnValueBlock;
@property (nonatomic,strong)NSString *saveNumber;//评分分数;
@property (nonatomic,strong)NSString *formName;//评分名字;
@property (nonatomic,strong)NSString *saveColumn;//评分选项;
@property (nonatomic,strong)NSString *formId;//评分id;
@end
