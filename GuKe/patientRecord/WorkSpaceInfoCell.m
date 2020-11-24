//
//  WorkSpaceInfoCellTableViewCell.m
//  GuKe
//
//  Created by yb on 2020/11/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoCell.h"
#import "WorkSpaceInfoCellModel.h"
#import "ZXFExpandTextView.h"

@interface WorkSpaceInfoCell ()

@property (nonatomic, strong) UIImageView *coverIV;
@property (nonatomic, strong) ZXFExpandTextView *expandTextView;


@end

@implementation WorkSpaceInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverIV];
        [self.contentView addSubview:self.expandTextView];
        [self addSubviewConstrains];
    }
    return self;
}

- (UIImageView *)coverIV
{
    if (!_coverIV) {
        _coverIV = [[UIImageView alloc] init];
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
        _coverIV.layer.cornerRadius = 5;
    }
    return _coverIV;
}

- (ZXFExpandTextView *)expandTextView
{
    if (!_expandTextView) {
        _expandTextView = [[ZXFExpandTextView alloc] init];
        _expandTextView.backgroundColor = [UIColor greenColor];
//        _expandView.textColor = [UIColor colorWithHex:0x3C3E3D];
//        _expandView.font = [UIFont systemFontOfSize:15];
//        _expandView.scrollEnabled = NO;
//        _infoView.numberOfLines = 4;
//        _infoView.preferredMaxLayoutWidth = ScreenWidth - 40;
    }
    return _expandTextView;
}


- (void)addSubviewConstrains
{
    CGFloat sidePadding = 20;
    CGFloat w = ScreenWidth - sidePadding * 2;
    CGFloat h = (140.0/335.0) * w;
    
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5);
        make.height.mas_equalTo(h);
        make.width.mas_equalTo(w);
    }];

//    [self.expandTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.coverIV.mas_bottom).offset(15);
//        make.left.equalTo(self.contentView).offset(sidePadding);
//        make.right.equalTo(self.contentView).offset(-sidePadding);
//        make.bottom.equalTo(self.contentView).offset(-5);
//    }];
    
//    self.coverIV.frame = CGRectMake(sidePadding, 5, w, h);
//
//    CGRect exf = self.coverIV.frame;
//    exf.origin.y += exf.size.height + 20;
//    exf.size.height = 80;//[self.expandTextView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height;
//    self.expandTextView.frame = exf;
//    CGRect viewRect = self.expandTextView.bounds;
//    viewRect.size.height += exf.origin.y + 20;
//    self.bounds = viewRect;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//
//
//}


- (void)configWithData:(WorkSpaceInfoCellModel *)data expand:(void (^ )(BOOL))expand
{
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:data.imgUrl] placeholderImage:[UIImage imageNamed:@"灰_bg"]];
//    self.infoLabel.text = data.content;
    if (!data.content.isValidStringValue) return;
    
    [self.expandTextView configureWithModel:data.textModel expand:^(BOOL expanded){
        if (expand != nil) {
            expand(expanded);
        }
        [self layoutIfNeeded];
    }];
    
    [self.expandTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverIV.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
}

@end
