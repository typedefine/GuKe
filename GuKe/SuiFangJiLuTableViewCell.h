//
//  SuiFangJiLuTableViewCell.h
//  GuKe
//
//  Created by yu on 2017/8/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuiFangJiLuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timelab;
@property (weak, nonatomic) IBOutlet UILabel *suifangTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *harrisPingfenLab;
@property (weak, nonatomic) IBOutlet UILabel *hssPingFen;
@property (weak, nonatomic) IBOutlet UILabel *sfPingFenLab;
@property (weak, nonatomic) IBOutlet UILabel *yingxiangxueLab;
@property (weak, nonatomic) IBOutlet UILabel *jianchaLab;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;

-(void)setCellWithdic:(NSDictionary *)dic;
@end
