//
//  ZJNAnesthesiaTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/6.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNAnesthesiaTableViewCellDelegate<NSObject>

-(void)zjnAnesthesiaTableViewCellSelectButtonWithType:(NSString *)type;

@end
@interface ZJNAnesthesiaTableViewCell : UITableViewCell
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *firstLabel;
@property (nonatomic ,strong)UILabel *secondLabel;
@property (nonatomic ,strong)UILabel *thirdLabel;
@property (nonatomic ,strong)UILabel *fourthLabel;
@property (nonatomic ,strong)UIButton *firstButton;
@property (nonatomic ,strong)UIButton *secondButton;
@property (nonatomic ,strong)UIButton *thirdButton;
@property (nonatomic ,strong)NSString *anesthesiaUid;
@property (nonatomic ,weak)id<ZJNAnesthesiaTableViewCellDelegate>delegate;
@end
