//
//  ZJNShareView.h
//  GuKe
//
//  Created by 朱佳男 on 2017/11/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNShareView : UIView
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewHeightConstraint;
-(void)show;
@end
