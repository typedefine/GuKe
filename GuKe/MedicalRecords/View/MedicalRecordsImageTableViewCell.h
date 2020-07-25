//
//  MedicalRecordsImageTableViewCell.h
//  GuKe
//
//  Created by 朱佳男 on 2017/9/29.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedicalRecordsImageTableViewCell;
@protocol medicalRecordsImageDelegate<NSObject>
@required
-(void)switchImageArrayWithType:(NSString *)type withCell:(MedicalRecordsImageTableViewCell *)cell;

@optional
-(void)showImageWithIndex:(NSInteger)index withCell:(MedicalRecordsImageTableViewCell *)cell;

-(void)comPareInfoWithCell:(MedicalRecordsImageTableViewCell *)cell;
-(void)editImageWithCell:(MedicalRecordsImageTableViewCell *)cell;
@end
@interface MedicalRecordsImageTableViewCell : UITableViewCell

@property (nonatomic ,assign)CGFloat topHeight;

@property (nonatomic ,strong)NSString *topStyle;

@property (nonatomic ,strong)NSArray  *imageArray;

@property (nonatomic ,weak)id<medicalRecordsImageDelegate>delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier topStyle:(NSString *)topStyle;

@end
