/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ConversationListController.h"

#import "ChatViewController.h"
//#import "RobotManager.h"
//#import "RobotChatViewController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
//#import "RedPacketChatViewController.h"
#import "ChatDemoHelper.h"

#import "UIViewController+SearchController.h"
#import "WYYFMDBManager.h"
#import "WYYYIshengFriend.h"
#import "SysmessageViewController.h"
@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.type == EMConversationTypeChat) {
//        if ([[RobotManager sharedInstance] isRobotWithUsername:self.conversationId]) {
//            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.conversationId];
//        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.conversationId];
    } else if (self.type == EMConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"subject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"subject"];
        }
    }
    return self.conversationId;
}

@end

@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,EMSearchControllerDelegate>{
    WYYFMDBManager *WYYManager;
    BOOL GetData;
    NSDate * comeDate;
}

@property (nonatomic, strong) UIView *networkStateView;

@end

@implementation ConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    GetData = YES;

    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    WYYManager = [WYYFMDBManager shareWYYManager];
    [self networkStateView];
    
    [self setupSearchController];
    
    [self tableViewDidTriggerHeaderRefresh];
    [self removeEmptyConversationsFromDB];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
    if (GetData) {
        comeDate =[NSDate date];
        
    }
    GetData = YES;

    //[self makeData];
}
 -(void)viewWillDisappear:(BOOL)animated{
    
     if (GetData) {
        [moduleDate ShareModuleDate].MessageLength =[[NSDate date]timeIntervalSinceDate:comeDate];
    }
    
}
#pragma mark  好友医生列表
- (void)makeData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinfreindlist];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *arays = [NSArray arrayWithArray:data[@"data"]];
            if (arays.count == 0) {
                
            }else{
                for (NSDictionary *dic in arays) {
                    WYYYIshengFriend *model = [WYYYIshengFriend yy_modelWithJSON:dic];
                    [WYYManager addFriendListModel:model];
                }
            }
        }
        NSLog(@"好友医生列表%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"好友医生列表%@",error);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
     NSLog(@"%@",model.conversation.conversationId);
    
    //    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
    //        NSMutableAttributedString *attributedText = [[self.dataSource conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
    //        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
    //        cell.detailLabel.attributedText =  attributedText;
    //    } else {
    //        cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    //    }
    
    cell.detailLabel.text = [self subTitleMessageByConversation:model.conversation];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [self.dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    WYYYIshengFriend *userModel = [WYYManager getFriendInfoModel:model.conversation.conversationId];
    

    NSDictionary *dicat = model.conversation.lastReceivedMessage.ext;
    
    if (model.conversation.type == EMConversationTypeGroupChat) {
        NSLog(@"%@",model.conversation.conversationId);
        WYYYIshengFriend *groupModel = [WYYManager getGroupInfoModel:model.conversation.conversationId];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",groupModel.groupname];
        [cell.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,groupModel.portrait]]placeholderImage:[UIImage imageNamed:@"医生好友_我的群组"]];
        NSLog(@"groupname = %@, portrait= %@ id= %@  ",groupModel.groupname,groupModel.portrait,groupModel.groupid);
        
    }else if ([dicat count] == 0) {
        
        cell.avatarView.image = [UIImage imageNamed:@"default_img"];
       [cell.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,userModel.portrait]] placeholderImage:[UIImage imageNamed:@"患者头像-占位图"]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",userModel.name];
//        系统消息的头像和昵称
        if([model.conversation.conversationId isEqualToString:@"gxsadmin"]){
            cell.avatarView.image = [UIImage imageNamed:@"sys_message_haeder"];
             cell.titleLabel.text = [NSString stringWithFormat:@"系统消息"];
         }
        
    }else{
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",[dicat objectForKey:@"userName"]];
        [cell.avatarView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dicat objectForKey:@"userPic"]]] placeholderImage:[UIImage imageNamed:@"患者头像-占位图"]];
    }
    
    
    return cell;
}
//得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    EMMessageBody * messageBody = lastMessage.body;
    if (lastMessage) {
        EMMessageBodyType  messageBodytype = lastMessage.body.type;
        switch (messageBodytype) {
                
                
                //                 EMMessageBodyTypeText   = 1,    /*! \~chinese 文本类型 \~english Text */
                //                EMMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
                //                EMMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
                //                EMMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
                //                EMMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
                //                EMMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
                //                EMMessageBodyTypeCmd,           /*! \~chinese 命令类型 \~english Command */
                
                
                
                
                //图像类型
            case EMMessageBodyTypeImage:
            {
                ret = NSLocalizedString(@"图片消息", @"[image]");
            } break;
                //文本类型
            case EMMessageBodyTypeText:
            {
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];  //表情映射
                ret = didReceiveText;
            } break;
                //语音类型
            case EMMessageBodyTypeVoice:
            {
                ret = NSLocalizedString(@"语音消息", @"[voice]");
            } break;
                //位置类型
            case EMMessageBodyTypeLocation:
            {
                ret = NSLocalizedString(@"地理位置信息", @"[location]");
            } break;
                //视频类型
            case EMMessageBodyTypeVideo:
            {
                ret = NSLocalizedString(@"视频消息", @"[video]");
            } break;
                
            case EMMessageBodyTypeFile:
            {
                ret = NSLocalizedString(@"文件消息", @"[file]");
            } break;
                
            default:
                break;
        }
    }
    
    return ret;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            UIViewController *chatController = nil;
#ifdef REDPACKET_AVALABLE
            //chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#else
            chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#endif
            WYYYIshengFriend *model;
            if (conversation.type == EMConversationTypeChat) {
                model = [WYYManager getFriendInfoModel:conversationModel.title];
                chatController.title = model.name;
            }else{
                model = [WYYManager getGroupInfoModel:conversationModel.title];
                chatController.title = model.groupname;
            }
// 根据发送消息的id 截取 跳转事件 ，跳转到系统消息列表
            if ([conversation.conversationId isEqualToString:@"gxsadmin"]) {
                SysmessageViewController * messageVC =[[SysmessageViewController alloc]init];
                messageVC.hidesBottomBarWhenPushed = YES ;
                [self.navigationController pushViewController:messageVC animated:YES];
            }else{
            
            chatController.hidesBottomBarWhenPushed = YES;
            GetData =NO ;
            [self.navigationController pushViewController:chatController animated:YES];
            }
//            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//                [self.navigationController pushViewController:chatController animated:YES];
//            } else {
//                UIViewController *chatController = nil;
//#ifdef REDPACKET_AVALABLE
//                chatController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//#else
//                chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//#endif
//                chatController.title = conversationModel.title;
//                [self.navigationController pushViewController:chatController animated:YES];
//            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        
        /*
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        } else {
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
            if (profileEntity) {
                model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
                model.avatarURLPath = profileEntity.imageUrl;
            }
        }
         */
        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
        if (profileEntity) {
            model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            model.avatarURLPath = profileEntity.imageUrl;
        }
        
        
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }

    
    return latestMessageTime;
}

#pragma mark - EMSearchControllerDelegate

- (void)cancelButtonClicked
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
}

- (void)searchTextChangeWithString:(NSString *)aString
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:aString collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.resultController.displaySource removeAllObjects];
                [weakSelf.resultController.displaySource addObjectsFromArray:results];
                [weakSelf.resultController.tableView reloadData];
            });
        }
    }];
}

#pragma mark - private 

- (void)setupSearchController
{
    [self enableSearchController];
    
    __weak ConversationListController *weakSelf = self;
    [self.resultController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
        EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        id<IConversationModel> model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        cell.model = model;

        cell.detailLabel.attributedText = [weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model];
        cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
        return cell;
    }];

    [self.resultController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return [EaseConversationCell cellHeightWithModel:nil];
    }];

    [self.resultController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [weakSelf.searchController.searchBar endEditing:YES];
        id<IConversationModel> model = [weakSelf.resultController.displaySource objectAtIndex:indexPath.row];
        EMConversation *conversation = model.conversation;
        ChatViewController *chatController;
#ifdef REDPACKET_AVALABLE
        // chatController = [[RedPacketChatViewController alloc]  initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#else
        chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
#endif
        chatController.title = [conversation showName];
//        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
//            chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//            chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
//        }else {
//#ifdef REDPACKET_AVALABLE
//            chatController = [[RedPacketChatViewController alloc]  initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//#else
//            chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//#endif
//            chatController.title = [conversation showName];
//        }
        GetData =NO ;
        [weakSelf.navigationController pushViewController:chatController animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [weakSelf.tableView reloadData];
                              
        [weakSelf cancelSearch];
    }];
    
//    UISearchBar *searchBar = self.searchController.searchBar;
//    [self.view addSubview:searchBar];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
//    self.tableView.frame = CGRectMake(0, searchBar.frame.size.height, self.view.frame.size.width,self.view.frame.size.height - searchBar.frame.size.height);
//    self.tableView.tableHeaderView = searchBar;
//    [searchBar sizeToFit];
}

#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

@end
