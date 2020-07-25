//
//  InfoOneTableViewCell.h
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *BtnOne;
@property (weak, nonatomic) IBOutlet UIButton *BtnTwo;
@property (weak, nonatomic) IBOutlet UITextField *historyText;
@property (nonatomic,strong)NSString *BtnString;
@end
