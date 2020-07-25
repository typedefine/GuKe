//
//  QJCAddBrandViewController.h
//  GuKe
//
//  Created by MYMAc on 2019/2/15.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^returnZhuanChang)(NSMutableArray *selecet);//选品牌


@interface QJCAddBrandViewController : UIViewController

@property (nonatomic,copy)returnZhuanChang returnZhuan;//选品牌
 - (void)returnZhuan:(returnZhuanChang)block;//选品牌
 
@property (nonatomic,strong)NSArray  *selectArray;
@property (nonatomic,strong)NSString *typeStr;
@end

NS_ASSUME_NONNULL_END
