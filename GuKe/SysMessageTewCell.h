//
//  SysMessageTewCell.h
//  GuKe
//
//  Created by MYMAc on 2019/3/19.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModels.h"
NS_ASSUME_NONNULL_BEGIN

@interface SysMessageTewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *MessageTitle;

@property (weak, nonatomic) IBOutlet UILabel *Messconcent;

@property (weak, nonatomic) IBOutlet UILabel *MessageTime;
@property (strong , nonatomic) MessageModels * model ;

@end

NS_ASSUME_NONNULL_END
