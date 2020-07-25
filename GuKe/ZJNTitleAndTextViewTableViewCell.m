//
//  ZJNTitleAndTextViewTableViewCell.m
//  TextFieldHeightChange2
//
//  Created by 朱佳男 on 2017/9/26.
//  Copyright © 2017年 ShangYuKeJi. All rights reserved.
//

#import "ZJNTitleAndTextViewTableViewCell.h"
#define kPadding 5

@interface ZJNTitleAndTextViewTableViewCell ()<UITextViewDelegate>
@property (nonatomic, strong) ZJNTextView *textView;
@end

@implementation ZJNTitleAndTextViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.textView];
    }
    return self;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 90, 30)];
        _titleLabel.font = Font14;
        _titleLabel.textColor = SetColor(0x1a1a1a);
    }
    return _titleLabel;
}
- (ZJNTextView *)textView
{
    if (_textView == nil) {
        CGRect cellFrame = self.contentView.bounds;
        cellFrame.origin.y += kPadding;
        cellFrame.size.height -= kPadding;
        cellFrame.origin.x += CGRectGetMaxX(self.titleLabel.frame)+10;
        cellFrame.size.width -= CGRectGetMaxX(self.titleLabel.frame)+20;
        _textView = [[ZJNTextView alloc] initWithFrame:cellFrame];
        _textView.delegate = self;
        _textView.textColor = detailTextColor;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.font = Font14;
        _textView.textAlignment = NSTextAlignmentRight;
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;

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
    return [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height + 2* kPadding;
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
-(void)textViewDidEndEditing:(UITextView *)textView{
    if(self.EndBlock){
        self.EndBlock(textView.text);
    }
}
- (void)textViewDidChange:(UITextView *)theTextView
{
    
    if ([self.expandableTableView.delegate conformsToProtocol:@protocol(ZJNTitleAndTextViewTableViewDelegate)]) {
        
        id<ZJNTitleAndTextViewTableViewDelegate> delegate = (id<ZJNTitleAndTextViewTableViewDelegate>)self.expandableTableView.delegate;
        NSIndexPath *indexPath = [self.expandableTableView indexPathForCell:self];
        
        // update the text
        _text = self.textView.text;
        
        [delegate tableView:self.expandableTableView
                updatedTitleAndTextViewText:_text
                atIndexPath:indexPath];
        
        CGFloat newHeight = [self cellHeight];
        CGFloat oldHeight = [delegate tableView:self.expandableTableView heightForRowAtIndexPath:indexPath];
        if (fabs(newHeight - oldHeight) > 0.01) {
            
            // update the height
            if ([delegate respondsToSelector:@selector(tableView:updatedTitleAndTextViewHeight:atIndexPath:)]) {
                [delegate tableView:self.expandableTableView
                      updatedTitleAndTextViewHeight:newHeight
                        atIndexPath:indexPath];
            }
            
            // refresh the table without closing the keyboard
            [self.expandableTableView beginUpdates];
            [self.expandableTableView endUpdates];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

#pragma mark -

@implementation UITableView (ZJNTitleAndTextViewTableViewCell)

- (ZJNTitleAndTextViewTableViewCell *)expandableTitleAndTextViewTextCellWithId:(NSString *)cellId
{
    ZJNTitleAndTextViewTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ZJNTitleAndTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.expandableTableView = self;
    }
    return cell;
}

@end
