//
//  GroupAddressbookCell.m
//  GuKe
//
//  Created by yb on 2021/1/6.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "GroupAddressbookCell.h"
#import "DDCButton.h"

@interface GroupAddressbookCell ()

@property(nonatomic, strong) UIImageView *portraitView;
@property(nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) DDCButton *action2;
@property (nonatomic, strong) DDCButton *action1;

@end

@implementation GroupAddressbookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat r = IPHONE_X_SCALE(35);
    [self.contentView addSubview:self.portraitView];
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(r);
    }];
    self.portraitView.clipsToBounds = YES;
    self.portraitView.layer.cornerRadius = r/2.0f;
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitView.mas_right).offset(IPHONE_X_SCALE(10));
        make.centerY.equalTo(self.contentView);
    }];
    
    CGFloat m_h = 20;
    [self.contentView addSubview:self.markLabel];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(m_h);
    }];
    self.markLabel.clipsToBounds = YES;
    self.markLabel.layer.cornerRadius = m_h/2.0f;
    
    
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.markLabel.hidden = YES;
    self.action2.hidden = YES;
    self.action1.hidden = YES;
}

- (void)addMarkAttributesWithData:(UserInfoModel *)data
{
    if (data.roleName.isValidStringValue) {
        self.markLabel.text = data.roleName;
        if (data.roleType == 1) {
            self.markLabel.textColor = [UIColor colorWithHex:0xF38D14];
            self.markLabel.backgroundColor = [UIColor colorWithHex:0xFFF6EC];
        }else if(data.roleType == 2){
            self.markLabel.textColor = greenC;
            self.markLabel.backgroundColor = [UIColor colorWithHex:0xE6F6F1];
        }else{
            self.markLabel.backgroundColor = [UIColor whiteColor];
        }
    }else{
        self.markLabel.text = @"";
        self.markLabel.textColor = [UIColor whiteColor];
    }
}

- (void)configWithData:(UserInfoModel *)data Type:(GroupAddressbookCellType)type
{
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:data.portrait] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nameLabel.text = data.name;
    
    switch (type) {
        case GroupAddressbookCellType_None:
        {
            
        }
            break;
            
        case GroupAddressbookCellType_Addressbook:
        {
            [self addMarkAttributesWithData:data];
        }
            break;
            
            
        case GroupAddressbookCellType_Manage:
        {
            [self addMarkAttributesWithData:data];
        }
            break;
            
            
        case GroupAddressbookCellType_RemoveRight:
        {
            [self addMarkAttributesWithData:data];
        }
            break;
            
        case GroupAddressbookCellType_InviteMember:
        {
            
        }
            break;
            
        case GroupAddressbookCellType_MemberApply:
        {
            
        }
            break;
            
        default:
            break;
    }
}






- (UIImageView *)portraitView
{
    if (!_portraitView) {
        _portraitView = [[UIImageView alloc] init];
    }
    return _portraitView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)markLabel
{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _markLabel.hidden = YES;
    }
    return _markLabel;
}

- (DDCButton *)action2
{
    if (!_action2) {
        _action2 = [[DDCButton alloc] init];
        _action2.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _action2.hidden = YES;
    }
    return _action2;
}

- (DDCButton *)action1
{
    if (!_action1) {
        _action1 = [[DDCButton alloc] init];
        _action1.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _action1.hidden = YES;
    }
    return _action2;
}



@end

