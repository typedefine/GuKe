//
//  ZJNTitleAndTextViewTableViewCell.h
//  TextFieldHeightChange2
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNTextView.h"
@protocol ZJNTitleAndTextViewTableViewDelegate <UITableViewDelegate>
@required
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)tableView:(UITableView *)tableView updatedTitleAndTextViewHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
@end
@interface ZJNTitleAndTextViewTableViewCell : UITableViewCell
@property (nonatomic, assign)NSTextAlignment *textAlignment;
@property (nonatomic, weak) UITableView *expandableTableView;
@property (nonatomic, strong, readonly) ZJNTextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) void(^EndBlock)(NSString * textViewText);
@end
#pragma mark--
@interface UITableView (ZJNExpandableTextTableViewCell)
- (ZJNTitleAndTextViewTableViewCell *)expandableTitleAndTextViewTextCellWithId:(NSString *)cellId;
@end
