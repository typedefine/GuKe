//
//  ZJNExpandableTextTableViewCell.h
//  TextFieldHeightChange2
//
//  Created by 朱佳男 on 2017/9/25.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJNTextView.h"
@protocol ZJNExpandableTextTableViewDelegate <UITableViewDelegate>
@required
- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)tableView:(UITableView *)tableView singleButtonSelect:(NSString *)type atIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView textViewEndEditingWithText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZJNExpandableTextTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView *expandableTableView;
@property (nonatomic, strong, readonly) ZJNTextView *textView;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UIButton*leftButton;
@property (nonatomic, strong)UIButton*rightButton;
@end
#pragma mark--
@interface UITableView (ZJNExpandableTextTableViewCell)
- (ZJNExpandableTextTableViewCell *)expandableTextCellWithId:(NSString *)cellId;
@end
