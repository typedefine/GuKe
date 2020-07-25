//
//  ZJNSelectDoctorTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/1.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNSelectDoctorTableViewCell : UITableViewCell
/** 头像 */
@property (nonatomic ,strong)UIImageView *headImageV;
/** 姓名 */
@property (nonatomic ,strong)UILabel *nameLabel;
/** 选中按钮 */
@property (nonatomic ,strong)UIImageView *selectImageV;
@end
