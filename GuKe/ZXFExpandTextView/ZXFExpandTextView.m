//
//  ZXFExpandTextView.m
//  GuKe
//
//  Created by yb on 2020/11/8.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFExpandTextView.h"
#import "ZXFExpandTextViewModel.h"


@interface ZXFExpandTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ZXFExpandTextViewModel *model;
@property (nonatomic, copy) NSString *prefix;
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
    self.prefix = @"expand";
    [self addSubview:self.textView];
//    self.textView.lin
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect viewRect = self.frame;
       
    viewRect.size.height = [self.textView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height;
       
    self.frame = viewRect;
}


- (void)configureWithModel:(ZXFExpandTextViewModel *)model expand:(ZXFExpandTextViewBlock)expand
{
    self.expand = [expand copy];
    if (!model || !model.text.isValidStringValue) return;
    self.model = model;
    if(model.expanded || self.model.text.length < 60 || self.model.lineNumForContraction == 0){
        [self fullText];
    }else{
        [self contractText];
    }
     
}

- (void)fullText
{
    self.textView.attributedText = nil;
    self.textView.textContainer.maximumNumberOfLines = 0;
    self.textView.text = self.model.text;
}

- (void)contractText
{
    self.textView.text = nil;
    self.textView.textContainer.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.textView.textContainer.maximumNumberOfLines = self.model.lineNumForContraction;
    NSString *trialText = @"查看全部";
    NSString *str = [[NSString stringWithFormat:@"%@%@",self.model.text,trialText] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSMutableAttributedString *a = [[NSMutableAttributedString alloc] initWithString:str];
    NSString *linkStr = [[NSString stringWithFormat:@"%@://%@",self.prefix,trialText] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];;
    [a addAttributes:@{NSLinkAttributeName:linkStr} range: NSMakeRange(str.length-trialText.length, trialText.length)];
    self.textView.attributedText = a;
    
}

- (BOOL)handleClick:(NSURL *)URL
{
    if ([[URL scheme] isEqualToString:self.prefix]) {
        NSLog(@"文字展开");
        if (self.expand != nil) {
            self.expand();
        }
        [self fullText];
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
        _textView.scrollEnabled = YES;
        _textView.delegate = self;
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
