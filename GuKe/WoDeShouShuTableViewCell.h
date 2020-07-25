//
//  WoDeShouShuTableViewCell.h
//  GuKe
//
//  Created by yu on 2017/8/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoDeShouShuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *buweiLab;
@property (weak, nonatomic) IBOutlet UILabel *mingchengLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
