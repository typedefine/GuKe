//
//  ZJNSignUpMeetingIntroduceTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/11/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReloadBlock)();
@interface ZJNSignUpMeetingIntroduceTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *htmlString;
@property(nonatomic,copy)ReloadBlock reloadBlock;
+(CGFloat)cellHeight;
@end
