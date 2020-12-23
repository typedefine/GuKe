//
//  ZXFInputBaseCell.h
//  GuKe
//
//  Created by saas on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZXFInputCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZXFInputBaseCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setup;

//- (void)configWithCellModel:(ZXFInputCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
