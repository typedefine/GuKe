//
//  WYYNewFriendTableViewCell.h
//  GuKe
//
//  Created by yu on 2018/1/18.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYYAddFriendList.h"
@interface WYYNewFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (nonatomic,strong)WYYAddFriendList *model;
- (void)setModel:(WYYAddFriendList *)model;
@end
