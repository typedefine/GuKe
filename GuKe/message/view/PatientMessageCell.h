//
//  PatientMessageCell.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/19.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class PatientMessageCellModel;
@interface PatientMessageCell : UITableViewCell

- (void)configureCellWithData:(PatientMessageCellModel *)data;

@end

NS_ASSUME_NONNULL_END
