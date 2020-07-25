//
//  ZJNSingleSelectTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/30.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNSingleSelectDelegate<NSObject>
-(void)singleSelectedWithType:(NSString *)type;
@end
@interface ZJNSingleSelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic ,weak)id<ZJNSingleSelectDelegate>delegate;
@end
