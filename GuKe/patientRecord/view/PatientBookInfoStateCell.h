//
//  PatientRecordBookCell.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientBookInfoStateCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PatientBookInfoStateCell : UICollectionViewCell

- (void)configureWithData:(PatientBookInfoStateCellModel *)data;

@end

NS_ASSUME_NONNULL_END
