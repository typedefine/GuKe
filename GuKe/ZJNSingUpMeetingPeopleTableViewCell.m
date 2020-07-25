//
//  ZJNSingUpMeetingPeopleTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNSingUpMeetingPeopleTableViewCell.h"
#import "ZJNHeaderImageAndNameView.h"
@interface ZJNSingUpMeetingPeopleTableViewCell ()
{
    UIView *whitesC;
}
@end
@implementation ZJNSingUpMeetingPeopleTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:237 green:237 blue:242 alpha:0];
        whitesC = [[UIView alloc]initWithFrame:CGRectMake(8, 8, ScreenWidth - 16, 134)];
        whitesC.layer.masksToBounds = YES;
        whitesC.layer.cornerRadius = 5;
        whitesC.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whitesC];
        
        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 20)];
        self.countLabel.textColor = greenC;
        self.countLabel.font = [UIFont systemFontOfSize:16];
        self.countLabel.text = @"已关注-人";
        [whitesC addSubview:self.countLabel];
        
        self.moreButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth -120, 10,100, 20)];
        [self.moreButton setTitle:@"更多关注" forState:normal];
        [self.moreButton setTitleColor:SetColor(0x999999) forState:normal];
        self.moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
        self.moreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        
        [self.moreButton setImage:[UIImage imageNamed:@"更多-箭头"] forState:normal];
        [whitesC addSubview:self.moreButton];
    }
    return self;
}
-(void)setModel:(ZJNMeetingInfoModel *)model{
    _model = model;
    self.countLabel.text = [NSString stringWithFormat:@"已关注%@人",[NSString changeNullString:self.model.count]];
    for (int i = 0; i <self.model.doctor.count; i ++) {
        NSDictionary *dic = self.model.doctor[i];
        ZJNHeaderImageAndNameView *view = [[ZJNHeaderImageAndNameView alloc]initWithFrame:CGRectMake(10+i*(45+10), 50, 45, 80)];
        [view.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,dic[@"portrait"]]] placeholderImage:[UIImage imageNamed:@"default_img"]];
        view.nameLabel.text = dic[@"doctorName"];
        [whitesC addSubview:view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
