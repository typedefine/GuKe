//
//  MessageController.h
//  GuKe
//
//  Created by 莹宝 on 2020/7/26.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageController : UIViewController

@property (nonatomic, strong) ConversationListController *chatListVC;


@end

NS_ASSUME_NONNULL_END
