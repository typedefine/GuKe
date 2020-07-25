//
//  ZJNGradeTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZJNGradeTableViewCellDelegate<NSObject>
@required
// 选中的是第几个评分项目
-(void)gradeButtonClickWithGradeType:(NSInteger )index;

@end
@interface ZJNGradeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLineLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLineMiddleLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstLineRightButton;

@property (weak, nonatomic) IBOutlet UILabel *secondLineLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLineMiddleLable;
@property (weak, nonatomic) IBOutlet UIButton *secondLineRightButton;

@property (weak, nonatomic) IBOutlet UILabel *thirdLineLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLineMiddleLabel;
@property (weak, nonatomic) IBOutlet UIButton *thirdLineRightButton;


@property (strong, nonatomic) NSMutableArray * PingfenArray;

@property (nonatomic ,strong)NSString *harrisString;
@property (nonatomic ,strong)NSString *HSSString;
@property (nonatomic ,strong)NSString *SF_12String;
@property (nonatomic ,weak)id<ZJNGradeTableViewCellDelegate>delegate;
@end
