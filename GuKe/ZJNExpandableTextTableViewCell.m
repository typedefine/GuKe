//
//  ZJNExpandableTextTableViewCell.m
//  TextFieldHeightChange2
//
//  Created by 朱佳男 on 2017/9/25.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import "ZJNExpandableTextTableViewCell.h"
#define kPadding 5

@interface ZJNExpandableTextTableViewCell ()<UITextViewDelegate>
@property (nonatomic, strong) ZJNTextView *textView;
@end

@implementation ZJNExpandableTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightButton];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.textView];
        
}
    return self;
}
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        _titleLabel.textColor = SetColor(0x1a1a1a);
        _titleLabel.font = Font14;
    }
    return _titleLabel;
}
-(UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+10, 20, 20);
        [_leftButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.selected = YES;
    }
    return _leftButton;
}
-(UILabel *)leftLabel{
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftButton.frame), CGRectGetMidY(_leftButton.frame)-10, 30, 20)];
        _leftLabel.textColor = SetColor(0x1a1a1a);
        _leftLabel.font = Font14;
    }
    return _leftLabel;
}
-(UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame)+5, CGRectGetMinY(_leftButton.frame), 20, 20);
        [_rightButton setImage:[UIImage imageNamed:@"性别_未选中"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"性别_选中"] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
-(UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_rightButton.frame), CGRectGetMinY(_leftButton.frame), 30, 20)];
        _rightLabel.textColor = SetColor(0x1a1a1a);
        _rightLabel.font = Font14;
    }
    return _rightLabel;
}
- (ZJNTextView *)textView
{
    if (_textView == nil) {
                
        CGRect cellFrame = self.contentView.bounds;
        cellFrame.origin.y += kPadding;
        cellFrame.size.height -= kPadding;
        cellFrame.origin.x = CGRectGetMaxX(_rightLabel.frame);
        cellFrame.size.width -= CGRectGetMaxX(_rightLabel.frame)+20;
        _textView = [[ZJNTextView alloc] initWithFrame:cellFrame];
        _textView.delegate = self;
        _textView.textColor = detailTextColor;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.font = Font14;
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.hidden = YES;
    }
    return _textView;
}
- (void)setText:(NSString *)text
{
    _text = text;
    
    // update the UI
    self.textView.text = text;
}
- (CGFloat)cellHeight
{
    return [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height + kPadding * 2;
}
#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // make sure the cell is at the top
    [self.expandableTableView scrollToRowAtIndexPath :[self.expandableTableView indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop
    animated:YES];
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)theTextView
{
    if ([self.expandableTableView.delegate conformsToProtocol:@protocol(ZJNExpandableTextTableViewDelegate)]) {
        
        id<ZJNExpandableTextTableViewDelegate> delegate = (id<ZJNExpandableTextTableViewDelegate>)self.expandableTableView.delegate;
        NSIndexPath *indexPath = [self.expandableTableView indexPathForCell:self];
        
        // update the text
        _text = self.textView.text;
        
        [delegate tableView:self.expandableTableView
                updatedText:_text
                atIndexPath:indexPath];
        
        CGFloat newHeight = [self cellHeight];
        CGFloat oldHeight = [delegate tableView:self.expandableTableView heightForRowAtIndexPath:indexPath];
        if (fabs(newHeight - oldHeight) > 0.01) {
            // update the height
            if ([delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)]) {
                [delegate tableView:self.expandableTableView
                      updatedHeight:newHeight
                        atIndexPath:indexPath];
            }
            // refresh the table without closing the keyboard
            [self.expandableTableView beginUpdates];
            [self.expandableTableView endUpdates];
        }
    }
}
#pragma mark--leftButton
-(void)leftButtonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    button.selected = !button.selected;
    if (button.selected) {
        self.rightButton.selected = NO;
        self.textView.hidden = YES;
    }
    if ([self.expandableTableView.delegate conformsToProtocol:@protocol(ZJNExpandableTextTableViewDelegate)]) {
        id<ZJNExpandableTextTableViewDelegate> delegate = (id<ZJNExpandableTextTableViewDelegate>)self.expandableTableView.delegate;
        NSIndexPath *indexPath = [self.expandableTableView indexPathForCell:self];
        [delegate tableView:self.expandableTableView singleButtonSelect:@"0" atIndexPath:indexPath];
    }
}
#pragma mark--rightButton
-(void)rightButtonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    button.selected = !button.selected;
    if (button.selected) {
        self.leftButton.selected = NO;
        self.textView.hidden = NO;
    }
    if ([self.expandableTableView.delegate conformsToProtocol:@protocol(ZJNExpandableTextTableViewDelegate)]) {
        id<ZJNExpandableTextTableViewDelegate> delegate = (id<ZJNExpandableTextTableViewDelegate>)self.expandableTableView.delegate;
        NSIndexPath *indexPath = [self.expandableTableView indexPathForCell:self];
        [delegate tableView:self.expandableTableView singleButtonSelect:@"1" atIndexPath:indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
#pragma mark -

@implementation UITableView (ZJNExpandableTextTableViewCell)

- (ZJNExpandableTextTableViewCell *)expandableTextCellWithId:(NSString *)cellId
{
    ZJNExpandableTextTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ZJNExpandableTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.expandableTableView = self;
    }
    return cell;
}

@end
