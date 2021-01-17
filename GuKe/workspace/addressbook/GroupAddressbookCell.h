//
//  GroupAddressbookCell.h
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GroupAddressbookCellType){
    GroupAddressbookCellType_None,
    GroupAddressbookCellType_Addressbook,
    GroupAddressbookCellType_Manage,
    GroupAddressbookCellType_RemoveRight,
    GroupAddressbookCellType_InviteMember,
    GroupAddressbookCellType_MemberApply
};

NS_ASSUME_NONNULL_BEGIN

@interface GroupAddressbookCell : UITableViewCell

- (void)configWithData:(UserInfoModel *)data Type:(GroupAddressbookCellType)type;

@end

NS_ASSUME_NONNULL_END
