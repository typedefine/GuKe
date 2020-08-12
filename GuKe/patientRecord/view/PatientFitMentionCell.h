//
//  PatientRecordFitMentionCell.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ inputBlock)(NSString *text);

@interface PatientFitMentionCell : UICollectionViewCell

- (void)configureCellWithData:(NSString *)data input:(inputBlock)input;

@end

NS_ASSUME_NONNULL_END
