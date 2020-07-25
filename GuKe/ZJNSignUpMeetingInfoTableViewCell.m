//
//  ZJNSignUpMeetingInfoTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/11/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNSignUpMeetingInfoTableViewCell.h"
@interface ZJNSignUpMeetingInfoTableViewCell()

@end

@implementation ZJNSignUpMeetingInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
}
-(void)setModel:(ZJNMeetingInfoModel *)model{
    _model = model;
    self.meetingNameLabel.text = self.model.meetingName;
//    self.admineNameLabel.text = self.model.doctorName;
    self.timeLabel.text = self.model.time;
    self.addressLabel.text = self.model.site;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
