//
//  DDCImageSelectorCell.m
//  DayDayCook
//
//  Created by Christopher Wood on 11/3/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "DDCImageSelectorCell.h"
#import "DDCImageModel.h"

#define kSelectBtnWidthHeight     40
#define kCamImgWidth              32
#define kCamImgHi                 27

@interface DDCImageSelectorCell()

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIButton    * selectBtn;
@property (nonatomic, strong) DDCImageModel *dataModel;
@property (nonatomic, copy) void (^ selectedBlock)(DDCImageModel *imageModel, UIButton *button);

@end

@implementation DDCImageSelectorCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.height.width.mas_equalTo(kSelectBtnWidthHeight);
    }];
    
    [self.selectBtn addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)selectBtnAction
{
//     self.dataModel.isSelected = self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectedBlock) {
        self.selectedBlock(self.dataModel, self.selectBtn);
    }
}

- (void)configureCellWithData:(DDCImageModel *)data
                     itemSize:(CGSize)itemSize
                selectedBlock:(void (^)(DDCImageModel *imageModel, UIButton *button))selectedBlock
{
    self.dataModel = data;
    self.selectedBlock = [selectedBlock copy];
    self.selectBtn.selected = data.isSelected;
    
    PHImageManager * manager = [PHImageManager defaultManager];
    if (self.tag != 0)
    {
        [manager cancelImageRequest:(int)self.tag];
    }
    if (data.image) {
        self.imageView.image = data.image;
    }else{
        PHAsset *asset = data.asset;
        self.tag = [manager requestImageForAsset:asset targetSize:itemSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.imageView.image = result;
        }];
    }
}


- (void)configureCellForCamera
{
    self.imageView.image = [UIImage imageNamed:@"camera"];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(kCamImgWidth);
        make.height.mas_equalTo(kCamImgHi);
    }];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"A5A4A4"];
    self.selectBtn.hidden = YES;
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = [UIImage imageNamed:@"default"];
}



-(UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

-(UIButton *)selectBtn
{
    if (!_selectBtn)
    {
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectBtn setImage:[UIImage imageNamed:@"unselect_photo"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"select_photo"] forState:UIControlStateSelected];
    }
    return _selectBtn;
}
@end
