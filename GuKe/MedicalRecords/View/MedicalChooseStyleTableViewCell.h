//
//  MedicalChooseStyleTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalChooseStyleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *diselectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
