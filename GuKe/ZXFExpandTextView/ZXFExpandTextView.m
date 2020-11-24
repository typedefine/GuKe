//
//  ZXFExpandTextView.m
//  GuKe
//
//  Created by yb on 2020/11/8.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFExpandTextView.h"
#import "ZXFExpandTextViewModel.h"

//static int min_text_len = 60;

@interface ZXFExpandTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ZXFExpandTextViewModel *model;
@property (nonatomic, copy) NSString *expandId;
@property (nonatomic, copy) NSString *constractId;
@property (nonatomic, copy) ZXFExpandTextViewBlock expand;

@end

@implementation ZXFExpandTextView

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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.expandId = @"expand";
    self.constractId = @"constract";
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    CGRect f = self.bounds;
//    self.textView.frame = f;
//    f.size = [self.textView sizeThatFits:CGSizeMake(f.size.width, MAXFLOAT)];
//    self.textView.frame = f;
//
//    CGRect viewRect = self.frame;
//
//    viewRect.size.height = [self.textView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height;
//
//    self.frame = viewRect;
//}


- (void)configureWithModel:(ZXFExpandTextViewModel *)model expand:(ZXFExpandTextViewBlock)expand
{
    self.expand = [expand copy];
    if (!model || !model.text.isValidStringValue) return;
    self.model = model;
    if(model.expanded || self.model.text.length < self.model.constractTextMaxLength || self.model.lineNumForContraction == 0){
        [self fullText];
    }else{
        [self contractText];
    }
     
}

- (void)fullText
{
    self.textView.textContainer.maximumNumberOfLines = 0;
    self.textView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *str = self.model.text;
    NSMutableAttributedString *a;
    if (str.length > self.model.constractTextMaxLength) {
        NSString *trialText = @" 收起内容";
        str = [NSString stringWithFormat:@"%@%@",str,trialText];
        a = [[NSMutableAttributedString alloc] initWithString:str];
        NSString *linkStr = [[NSString stringWithFormat:@"%@://%@",self.constractId,trialText] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];;
        [a addAttributes:@{NSLinkAttributeName:linkStr, NSForegroundColorAttributeName:greenC} range: NSMakeRange(str.length-trialText.length, trialText.length)];
    }else{
        a = [[NSMutableAttributedString alloc] initWithString:str];
    }
//    [a addAttributes:@{NSForegroundColorAttributeName:greenC} range: NSMakeRange(str.length-trialText.length, trialText.length)];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 10;
    ps.maximumLineHeight = 15;
    ps.minimumLineHeight = 8;
    ps.paragraphSpacing = 10;
    ps.firstLineHeadIndent = 20;
    UIFont *font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [a addAttributes:@{NSParagraphStyleAttributeName:ps, NSFontAttributeName:font} range:NSMakeRange(0, str.length)];
    self.textView.attributedText = a;
}

- (void)contractText
{
    self.textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textView.textContainer.maximumNumberOfLines = self.model.lineNumForContraction;
    NSString *str = self.model.text;
    NSMutableAttributedString *a;
    if (str.length > self.model.constractTextMaxLength) {
        NSString *showText = [self.model.text substringToIndex:self.model.constractTextMaxLength];
        NSString *trialText = @"查看全部";
        str = [NSString stringWithFormat:@"%@......%@",showText,trialText];
        a = [[NSMutableAttributedString alloc] initWithString:str];
        NSString *linkStr = [[NSString stringWithFormat:@"%@://%@",self.expandId,trialText] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];;
        [a addAttributes:@{NSLinkAttributeName:linkStr, NSForegroundColorAttributeName:greenC} range: NSMakeRange(str.length-trialText.length, trialText.length)];
    }else{
        a = [[NSMutableAttributedString alloc] initWithString:str];
    }
//    [a addAttributes:@{NSForegroundColorAttributeName:greenC} range: NSMakeRange(str.length-trialText.length, trialText.length)];
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = 10;
    ps.maximumLineHeight = 15;
    ps.minimumLineHeight = 8;
    ps.paragraphSpacing = 10;
    ps.firstLineHeadIndent = 20;
    UIFont *font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [a addAttributes:@{NSParagraphStyleAttributeName:ps, NSFontAttributeName:font} range:NSMakeRange(0, str.length)];
    self.textView.attributedText = a;
    
}

- (BOOL)handleClick:(NSURL *)URL
{
    if ([[URL scheme] isEqualToString:self.expandId]) {
        NSLog(@"文字展开");
        if (self.expand != nil) {
            self.expand(YES);
        }
        [self fullText];
        [self updateConstraints];
        return NO;
    }else{
        NSLog(@"文字收起");
        if (self.expand != nil) {
            self.expand(NO);
        }
        [self contractText];
        [self updateConstraints];
        return NO;
    }
    return YES;
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return [self handleClick:URL];
}

#else

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return [self handleClick:URL];
}

#endif

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.textColor = [UIColor colorWithHex:0x3C3E3D];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.editable = NO;
        _textView.tintColor = greenC;
//        _textView.backgroundColor = [UIColor redColor];
    }
    return _textView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
