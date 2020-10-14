//
//  PhotoChoseView.h
//  GuKe
//
//  Created by yu on 2017/8/4.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChoseViewDelegate <NSObject>

- (void)makeSelectBtnOne;
- (void)makeSelectBtnTwo;
- (void)makeSelectBtnThree;
@end

@interface PhotoChoseView : UIView
@property (nonatomic,strong)UIButton *ButtonOne;
@property (nonatomic,strong)UIButton *ButtonTwo;
@property (nonatomic,strong)UIButton *ButtonThree;
@property (nonatomic, weak) id<ChoseViewDelegate> delegate;

+ (id)makeAddButton;
@end
