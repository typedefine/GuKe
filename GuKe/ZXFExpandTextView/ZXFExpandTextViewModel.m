//
//  ZXFExpandTextViewModel.m
//  GuKe
//
//  Created by yb on 2020/11/9.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFExpandTextViewModel.h"

@implementation ZXFExpandTextViewModel
//{
//    NSString *_lessText, *_fullText;
//    NSMutableAttributedString *_lestxt, *_fultxt;
//}
//
//- (instancetype)init
//{
//    if (self = [super init]) {
//        _lineNumForContraction = 0;
//        _lessText = @"";
//        _lestxt = [[NSMutableAttributedString alloc] init];
//        _fullText = @"";
//        _fultxt = [[NSMutableAttributedString alloc] init];
//        _lineNumForContraction = 0;
//        _lineHeight = 20;
//        _maxWidth = [UIScreen mainScreen].bounds.size.width-20*2;
//        _font = [UIFont systemFontOfSize:15];
//        _textColor = [UIColor colorWithHex:0x3C3E3D];
//        _tintColor = greenC;
//    }
//    return self;
//}
//
//- (NSString *)text
//{
//    if (self.expanded) {
//        return _fullText;
//    }
//    return _lessText;
//}
//
//- (NSAttributedString *)displayText
//{
//    if (self.expanded) {
//        return _fultxt;
//    }
//    return _lestxt;
//}
//
//- (void)setText:(NSString *)text
//{
//    if(!text.isValidStringValue) return;
//
//    _fullText = text;
//    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
//
//    ps.lineSpacing = self.lineHeight;
//    if (self.lineNumForContraction == 0) {
//        _lessText = text;
////        ps.lineBreakMode = NSLineBreakByWordWrapping;
//    }else{
////        ps.lineBreakMode = NSLineBreakByTruncatingMiddle;
////        CGFloat textHeight = [text boundingRectWithSize:CGSizeMake(_maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:ps} context:nil].size.height;
////        float contraction_height = self.lineHeight * self.lineNumForContraction;
////        if (textHeight > contraction_height) {
////
////        }else{
////            _lessText = text;
////        }
//        _lessText = [NSString stringWithFormat:@"%@%@",_fullText, @"……查看全部"];
//    }
//
//    _fultxt = [[NSMutableAttributedString alloc] initWithString:_fullText];
//    _fultxt addAttributes:<#(nonnull NSDictionary<NSAttributedStringKey,id> *)#> range:<#(NSRange)#>
//    _lestxt = [[NSMutableAttributedString alloc] initWithString:_lessText];
//
//}


@end
