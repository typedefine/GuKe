//
//  ZJNMRSharesTableViewCell.h
//  MrBone_PatientProject
//
//  Created by 朱佳男 on 2018/1/20.
//  Copyright © 2018年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJNMRSharesTableViewCellDelegate<NSObject>
//删除病历共享者
-(void)deleteSharesDoctorWithArray:(NSArray *)newDoctorArr;
//添加病历共享者
-(void)zjnMRSharesTableViewaddSharesDoctor;
@end
typedef NS_ENUM(NSInteger ,ZJNMRSharesTableViewCellType){
    ZJNMRSharesTableViewCellShow = 0,
    ZJNMRSharesTableViewCellEditing
};
@interface ZJNMRSharesTableViewCell : UITableViewCell
/** 嵌套在cell上的collectionView */
@property (nonatomic ,strong)UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic ,strong)NSArray *dataArray;
/** 代理 */
@property (nonatomic ,weak)id<ZJNMRSharesTableViewCellDelegate>delegate;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(ZJNMRSharesTableViewCellType)type;
@end
