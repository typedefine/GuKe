//
//  MsgChatInputBar.h
//  GuKe
//
//  Created by 莹宝 on 2020/8/25.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void (^ inputChanged)(NSString *text, CGFloat textHeight, CGFloat totalHeight);

@class MsgChatInputBar;

@protocol MsgChatInputBarDelegate <NSObject>

@optional

- (void)inputBarChanged:(MsgChatInputBar *)inputBar;
- (void)inputBarSendAction:(MsgChatInputBar *)inputBar;

@end

@interface MsgChatInputBar : UIView

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) CGSize textSize;
@property (nonatomic, readonly) CGSize barSize;
@property (nonatomic, weak, nullable) id<MsgChatInputBarDelegate> delegate;
- (void)reset;
//- (void)configureWithInput:(inputChanged)input;

@end

NS_ASSUME_NONNULL_END
