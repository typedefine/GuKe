//
//  ZJNScrollTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNScrollTableViewCell.h"

@implementation ZJNScrollTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.scrollView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
-(void)setTypeArray:(NSArray *)typeArray{
    
    _typeArray = typeArray;
    [self.scrollView removeAllSubviews];
    float width = 0;
    for (int i = 0; i <_typeArray.count; i ++) {
        
        NSDictionary *dic = _typeArray[i];
        NSString *typeStr = dic[@"jointsName"];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:Font14,NSFontAttributeName, nil];
        float lablewidth = [typeStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width+10;
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 12, lablewidth, 20)];
        typeLabel.font = Font14;
        typeLabel.text = typeStr;
        typeLabel.textColor = SetColor(0x999999);
        typeLabel.backgroundColor = SetColor(0xebebeb);
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.layer.masksToBounds = YES;
        typeLabel.layer.cornerRadius = 2;
        [self.scrollView addSubview:typeLabel];
        
        width += 10+lablewidth;
    }
    self.scrollView.contentSize = CGSizeMake(width, 0);
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 116, 44)];
        _titleLabel.font = Font14;
        _titleLabel.textColor = SetColor(0x1a1a1a);
    }
    return _titleLabel;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)- 40, 0, ScreenWidth-CGRectGetMaxX(_titleLabel.frame), 44)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
 - (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
