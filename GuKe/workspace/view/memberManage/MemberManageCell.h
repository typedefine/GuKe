//
//  MemberManageCell.h
//  GuKe
//
//  Created by saas on 2020/12/31.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MemberManageCell : UITableViewCell

//@property(nonatomic, copy) NSString *portrait;
//@property(nonatomic, copy) NSString *name;

- (void)configWithData:(UserInfoModel *)data;

@end

NS_ASSUME_NONNULL_END
