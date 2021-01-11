//
//  AddMembersController.h
//  GuKe
//
//  Created by yb on 2021/1/12.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InviteMembersAction) {
    InviteMembersActionByAddingGroup  = 0,//创建小组
    InviteMembersActionByAddingFriend,//群组拉人
};
typedef void (^backGroupNumber) (NSMutableArray *groupDic);//创建群组
typedef void (^backAddNumber) (NSMutableArray *numberArr);//群组拉人
@interface AddMembersController : BaseViewController
@property (nonatomic, copy)backGroupNumber backgroupnumber;//创建群组
@property (nonatomic, copy)backAddNumber backaddnumber;////群组拉人
@property (nonatomic ,assign)InviteMembersAction action;
@property (nonatomic,strong)NSArray *GroupNumberArr;//群成员是否在里面
@end

NS_ASSUME_NONNULL_END
