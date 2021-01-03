//
//  ZXFInputImageCell.m
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFInputImageCell.h"

@interface ZXFInputImageView : UIImageView

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UILabel *indicateLabel;

@end

@implementation ZXFInputImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    [self addSubview:self.addLabel];
    [self addSubview:self.indicateLabel];
    
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
        make.height.mas_equalTo(IPHONE_Y_SCALE(25));
    }];
    [self.indicateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.addLabel.mas_bottom).offset(IPHONE_Y_SCALE(12));
    }];
}

- (void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    self.addLabel.hidden = imgUrl.isValidStringValue;
    self.indicateLabel.hidden = imgUrl.isValidStringValue;
//    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    self.addLabel.hidden = image.isValidObjectValue;
    self.indicateLabel.hidden = image.isValidObjectValue;
}

- (UILabel *)addLabel
{
    if (!_addLabel) {
        _addLabel = [[UILabel alloc] init];
        _addLabel.text = @"+";
        _addLabel.textColor = [UIColor colorWithHex:0xD0D0D0];
        _addLabel.font = [UIFont systemFontOfSize:50 weight:UIFontWeightRegular];
    }
    return _addLabel;
}

- (UILabel *)indicateLabel
{
    if (!_indicateLabel) {
        _indicateLabel = [[UILabel alloc] init];
        _indicateLabel.text = @"添加图片";
        _indicateLabel.textColor = [UIColor colorWithHex:0xD0D0D0];
        _indicateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _indicateLabel;
}

@end

@interface ZXFInputImageCell ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ZXFInputImageView *indicateView;
@property (nonatomic, strong) UIImagePickerController *imagePickController;//选择图像
@property (nonatomic, weak) UIViewController *targetController;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *imgData;
@property (nonatomic, copy) void (^ pickAction)(id data);

@end

@implementation ZXFInputImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
        make.top.equalTo(self.contentView).offset(IPHONE_X_SCALE(5));
    }];
    
    [self.contentView addSubview:self.indicateView];
    [self.indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(IPHONE_X_SCALE(15));
        make.size.mas_equalTo(IPHONE_X_SCALE(100));
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.indicateView.imgUrl = nil;
}

- (void)configureWithTarget:(UIViewController *)targetController
                      title:(NSString *)title
                   indicate:(NSString *)indicate
                 completion:(void (^)(id data))completion
{
    self.targetController = targetController;
    if (title.isValidStringValue) {
        self.titleLabel.text = title;
        CGFloat w = [Tools sizeOfText:title andMaxSize:CGSizeMake(CGFLOAT_MAX, 20) andFont:self.titleLabel.font].width + 2;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(IPHONE_X_SCALE(5));
            make.left.equalTo(self.contentView).offset(IPHONE_X_SCALE(20));
            make.width.mas_equalTo(w);
        }];
    }
    self.indicateView.indicateLabel.text = indicate;
    self.pickAction = [completion copy];
}


#pragma mark -- 调用系统相机
// 调用相机
- (void)addPicEventWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    // 先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePickController.sourceType = sourceType;
    
    [self.targetController presentViewController:self.imagePickController animated:YES completion:^{
        
    }];
}
// delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    [self performSelector:@selector(uploadImageToOSS:)
               withObject:image
               afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// 照片处理
- (void)uploadImageToOSS:(UIImage *)image {
    self.indicateView.image = image;
    [self setNeedsDisplay];
//    [self layoutIfNeeded];
    NSData *data = UIImageJPEGRepresentation(image, proportion);
    self.imgData = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    //上传图片
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,uploadimageUpload];
    NSArray *keysArray = @[@"fromFile"];
    NSArray *valueArray = @[self.imgData];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            self.imgUrl = [arrays componentsJoinedByString:@","];
            if (self.pickAction && self.imgUrl) {
                self.pickAction(self.imgUrl);
            }
        }
    
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark  图像
- (void)chosePhoto
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更改头像" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        
        [weakSelf addPicEventWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"从图库选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"图库");
        
        [weakSelf addPicEventWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [alert addAction:photoAction];
    [alert addAction:pictureAction];
    [alert addAction:cancelAction];
    //弹出提示框；
    [self.targetController presentViewController:alert animated:YES completion:nil];
}


- (ZXFInputImageView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[ZXFInputImageView alloc] init];
        _indicateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        [_indicateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chosePhoto)]];
    }
    return _indicateView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithHex:0x3C3E3D];
    }
    return _titleLabel;
}

- (UIImagePickerController *)imagePickController
{
    if (!_imagePickController) {
        _imagePickController = [[UIImagePickerController alloc] init];
        _imagePickController.delegate = self;
        _imagePickController.allowsEditing = YES;
    }
    return _imagePickController;
}


@end
