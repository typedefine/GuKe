//
//  PatientBookCell.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PatientMessageModel;

typedef void (^ replyBlock)(PatientMessageModel *model);

@class PatientBookCellModel;
@interface PatientBookCell : UITableViewCell

- (void)configureCellWithData:(PatientBookCellModel *)data reply:(replyBlock)reply;

@end

NS_ASSUME_NONNULL_END
