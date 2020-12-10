//
//  WorkGroupCollectionViewCell.m
//  GuKe
//
//  Created by yb on 2020/11/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupItemCell.h"


@interface WorkGroupItemCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) GroupInfoModel *cellModel;

@end

@implementation WorkGroupItemCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHex:0xEDF1F4];
        [self.contentView clipCornerWithCornerRadius:10];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailButton];
        
        CGFloat y_margin = IPHONE_Y_SCALE(7);
        
        CGFloat imageSize = IPHONE_X_SCALE(60);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(y_margin);
            make.size.mas_equalTo(imageSize);
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(60);
        }];
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = imageSize/2.0;
//        [self.imageView clipCornerWithCornerRadius:imageSize/2.0];
//        [self.imageView addCornerWithRadius:imageSize/2.0];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.width.mas_equalTo(90);
        }];
        
        CGFloat btnHeight = IPHONE_Y_SCALE(25);
        CGFloat btnWidth = IPHONE_Y_SCALE(70);
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnHeight);
            make.bottom.equalTo(self.contentView).offset(-y_margin);
        }];
        self.detailButton.clipsToBounds = YES;
        self.detailButton.layer.cornerRadius = btnHeight/2.0;
//        [self.detailButton clipCornerWithCornerRadius:13];
        [self.detailButton setEnlargeEdgeWithTop:15 right:0 bottom:15 left:0];
        [self.detailButton addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.detailButton.enabled = NO;
    }
    return self;
}

- (void)detailButtonAction
{
//    if (self.cellModel && self.cellModel.groupId && self.cellModel.action && self.cellModel.target && [self.cellModel.target respondsToSelector:self.cellModel.action]) {
//        [self.cellModel.target performSelector:self.cellModel.action withObject:self.cellModel.groupId];
//    }
}

- (void)configCellWithData:(GroupInfoModel *)dataModel
{
    self.cellModel = dataModel;
    if (dataModel) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:dataModel.portrait] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        self.titleLabel.text = dataModel.groupname;
    }
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
//        _imageView.clipsToBounds = YES;
        
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithHex:0x626262];
    }
    return _titleLabel;
}

- (UIButton *)detailButton
{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.backgroundColor = greenC;
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_detailButton setTitle:@"了解详情" forState:UIControlStateNormal];
    }
    return _detailButton;
}




@end
