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
    GroupAddressbookCellType_RemoveRightSelected,
    GroupAddressbookCellType_RemoveRightUnselected,
    GroupAddressbookCellType_InviteMember,
    GroupAddressbookCellType_MemberApply
};

typedef void (^ AddressbookAction)(UserInfoModel * _Nonnull user);

NS_ASSUME_NONNULL_BEGIN

@interface GroupAddressbookCell : UITableViewCell

@property (nonatomic, copy) AddressbookAction action1;
@property (nonatomic, copy) AddressbookAction action2;

- (void)configWithData:(UserInfoModel *)data type:(GroupAddressbookCellType)type;


@end

NS_ASSUME_NONNULL_END
