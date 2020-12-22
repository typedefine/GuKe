//
//  ZXFInputFieldCell.m
//  GuKe
//
//  Created by yb on 2020/12/22.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFInputFieldCell.h"
#import "ZXFInputField.h"

@interface ZXFInputFieldCell ()

@property (nonatomic, strong) ZXFInputField *inputField;

@end

@implementation ZXFInputFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.inputField];
        [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)configWithTitle:(NSString *)title
            placeholder:(NSString *)placeholder
             completion:(void (^)(NSString *text))completion
{
    [self.inputField configWithTitle:title placeholder:placeholder completion:completion];
}

- (ZXFInputField *)inputField
{
    if (!_inputField) {
        _inputField = [[ZXFInputField alloc] init];
    }
    return _inputField;
}


@end
