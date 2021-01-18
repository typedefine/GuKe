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
    
    
    [self.contentView addSubview:self.action1];
    [self.action1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    
    [self.contentView addSubview:self.action2];
    [self.action2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.action1.mas_left).offset(-IPHONE_X_SCALE(11));
        make.centerY.equalTo(self.contentView);
    }];
    
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.nameLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    self.markLabel.text = @"";
    self.markLabel.textColor = [UIColor whiteColor];
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
        self.markLabel.hidden = NO;
    }
//    else{
//        self.markLabel.text = @"";
//        self.markLabel.textColor = [UIColor whiteColor];
//        self.markLabel.hidden = YES;
//    }
}

- (void)addAddressbookActions
{
    CGFloat btn_w = IPHONE_X_SCALE(65), btn_h = IPHONE_X_SCALE(25);
    self.action1.hidden = NO;
    [self.action1 setImage:[UIImage imageNamed:@"group_tochat"] forState:UIControlStateNormal];
    [self.action1 setTitle:@" 发消息" forState:UIControlStateNormal];
    [self.action1 setTitleColor:[UIColor colorWithHex:0x3C3E3D] forState:UIControlStateNormal];
    [self.action1 setLayerBorderColor:[UIColor colorWithHex:0xD5D9DC] forState:UIControlStateNormal];
    [self.action1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(btn_w);
        make.height.mas_equalTo(btn_h);
    }];
    self.action1.clipsToBounds = YES;
    self.action1.layer.cornerRadius = btn_h/2.0f;
    
    
    self.action2.hidden = NO;
    [self.action2 setImage:[UIImage imageNamed:@"group_invite"] forState:UIControlStateNormal];
    [self.action2 setTitle:@" 加好友" forState:UIControlStateNormal];
    [self.action2 setTitleColor:[UIColor colorWithHex:0x3C3E3D] forState:UIControlStateNormal];
    [self.action2 setLayerBorderColor:[UIColor colorWithHex:0xD5D9DC] forState:UIControlStateNormal];
    [self.action2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.action1.mas_left).offset(-IPHONE_X_SCALE(11));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(btn_w);
        make.height.mas_equalTo(btn_h);
    }];
    self.action2.clipsToBounds = YES;
    self.action2.layer.cornerRadius = btn_h/2.0f;
}

- (void)addManageAction
{
    self.action1.hidden = NO;
    [self.action1 setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [self.action1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(4);
    }];
    [self.action1 setEnlargeEdgeWithTop:20 right:15 bottom:20 left:15];
}

- (void)addRemoveRightAction
{
    self.action1.hidden = NO;
    [self.action1 setImage:[UIImage imageNamed:@"group_remove_right"] forState:UIControlStateNormal];
    [self.action1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-IPHONE_X_SCALE(20));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(12);
    }];

    self.action2.hidden = NO;
    [self.action2 setImage:[UIImage imageNamed:@"group_invite"] forState:UIControlStateNormal];
    [self.action2 setTitle:@"移交管理权限" forState:UIControlStateNormal];
    [self.action2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.action2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.action1.mas_left).offset(-IPHONE_X_SCALE(9));
        make.centerY.equalTo(self.contentView);
//        make.width.mas_equalTo(btn_w);
//        make.height.mas_equalTo(btn_h);
    }];
    self.action2.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
}

- (void)configWithData:(UserInfoModel *)data type:(GroupAddressbookCellType)type
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
            [self addAddressbookActions];
        }
            break;
            
            
        case GroupAddressbookCellType_Manage:
        {
            [self addMarkAttributesWithData:data];
            [self addManageAction];
        }
            break;
            
            
        case GroupAddressbookCellType_RemoveRight:
        {
            self.nameLabel.textColor = [UIColor whiteColor];
            [self addMarkAttributesWithData:data];
            self.markLabel.backgroundColor = [UIColor whiteColor];
            [self addRemoveRightAction];
            self.contentView.backgroundColor = greenC;
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
    return _action1;
}



@end

