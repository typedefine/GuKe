//
//  FakeNavBar.m
//  DayDayCook
//
//  Created by Christopher Wood on 8/19/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

#import "FakeNavBar.h"
//#import "DDCRedBubbleView.h"
#define kTextBtnPad       5
#define MIN_BUTTON   40.

static const CGFloat kRedBubbleWidth = 26.0f;
static const CGFloat kRedBubbleHeight = 16.0f;

@interface FakeNavBar()
{
    UILabel  * _titleLabel;
    UIButton * _leftButton;
    UIButton * _rightButton;
    UIView  * _bottomLine;
    UIColor  * _bgColor;
    BOOL      _hidden;
//    CALayer  * _redDotLayer;
}
//@property (nonatomic, strong) DDCRedBubbleView *redBubbleView;

@end

@implementation FakeNavBar

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString*)title
                   textColor:(UIColor*)textColor
             leftButtonImage:(UIImage*)leftButtonImage
        leftButtonImageColor:(UIColor*)leftButtonImageColor
            rightButtonImage:(UIImage*)rightButtonImage
       rightButtonImageColor:(UIColor*)rightButtonImageColor
                    delegate:(id<FakeNavBarDelegate>)delegate
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = delegate;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _titleLabel.text = title;
    if (@available(iOS 8.2, *)) {
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        _titleLabel.font = Font18;
    }
    _titleLabel.textColor = textColor ? textColor : [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_titleLabel];
    
    if (leftButtonImage)
    {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_leftButton setImage:leftButtonImage forState:UIControlStateNormal];
        [_leftButton.imageView setTintColor:leftButtonImageColor ? leftButtonImageColor : [UIColor clearColor]];
        [_leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [_leftButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [self addSubview:_leftButton];
    }
    
    if (rightButtonImage)
    {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightButton setImage:rightButtonImage forState:UIControlStateNormal];
        [_rightButton.imageView setTintColor:rightButtonImageColor ? rightButtonImageColor : [UIColor clearColor]];
        _rightButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
        [_rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [self addSubview:_rightButton];
        
    }
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];//[UIColor colorWithHexString:@"#DCDCDC"];
    [self addSubview:_bottomLine];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_leftButton)
    {
        if (_leftButton.constraints.count == 0)
        {
            [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14);
                make.top.equalTo(self).with.offset(StatusBar_Height);//设计说的
                make.width.mas_equalTo(MIN_BUTTON);
                make.height.mas_equalTo(MIN_BUTTON);
            }];
        }
    }
    
    if (_rightButton)
    {
        if (_rightButton.constraints.count == 0)
        {
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14);
                make.top.equalTo(self).with.offset(StatusBar_Height);
                make.width.mas_equalTo(MIN_BUTTON);
                make.height.mas_equalTo(MIN_BUTTON);
            }];
            
        }
    }
    
    if (_titleLabel.constraints.count == 0)
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerX.equalTo(self);
            if (self->_leftButton)
            {
                make.left.equalTo(self->_leftButton.mas_right).with.offset(5);
                make.centerY.equalTo(self->_leftButton);
            }
            else if (self->_rightButton)
            {
                make.right.equalTo(self->_rightButton.mas_left).with.offset(-5);
                make.centerY.equalTo(self->_rightButton);
            }
            else
            {
                make.right.equalTo(self).with.offset(-5);
                make.centerY.equalTo(self).with.offset(StatusBar_Height/2);
            }
            
        }];
    }
    
    if (_bottomLine.constraints.count == 0)
    {
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
}

-(void)leftButtonPressed
{
    [self.delegate didTapLeftBarButton];
}

-(void)rightButtonPressed
{
    [self.delegate didTapRightBarButton];
}

#pragma mark - 私立

-(void)setHidden:(BOOL)hidden
{
    switch (_hiddenType)
    {
        case HiddenTypeAllHidden:
        {
            [super setHidden:hidden];
            for (UIView * view in self.subviews)
            {
                [view setHidden:hidden];
            }
        }
            break;
            
        case HiddenTypeTitleHidden:
        {
            [super setHidden:NO];
            [_rightButton setHidden:NO];
            [_leftButton setHidden:NO];
            [_titleLabel setHidden:hidden];
        }
            break;
            
        case HiddenTypeAllButtonsHidden:
        {
            [super setHidden:NO];
            [_titleLabel setHidden:NO];
            for (UIView * view in self.subviews)
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    [view setHidden:hidden];
                }
            }
        }
            break;
            
        case HiddenTypeLeftButtonAndTitleHidden:
        {
            [super setHidden:NO];
            [_rightButton setHidden:NO];
            [_leftButton setHidden:hidden];
            [_titleLabel setHidden:hidden];
        }
            break;
            
        case HiddenTypeRightButtonAndTitleHidden:
        {
            [super setHidden:NO];
            [_leftButton setHidden:NO];
            [_rightButton setHidden:hidden];
            [_titleLabel setHidden:hidden];
        }
            break;
        case HiddenTypeBottomLine:
        {
            [super setHidden:NO];
            [_leftButton setHidden:NO];
            [_rightButton setHidden:NO];
            [_titleLabel setHidden:NO];
            [_bottomLine setHidden:hidden];
        }
            break;
        default:
            break;
    }
    
    self.backgroundColor = hidden ? [UIColor clearColor] : _bgColor;
    [_bottomLine setHidden:hidden];
    _hidden = hidden;
}

// 因为系统需要用isHidden，所以我们用这个hiding属性
-(BOOL)hiding
{
    return _hidden;
}

-(BOOL)isHidden
{
    return [super isHidden];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (backgroundColor != [UIColor clearColor])
    {
        _bgColor = backgroundColor;
    }
    [super setBackgroundColor:backgroundColor];
}

#pragma mark - Setters
-(void)setLeftButtonImage:(UIImage *)newLeftButtonImage leftButtonColor:(UIColor*)newLeftButtonColor
{
    if (newLeftButtonImage)
    {
        if (!_leftButton)
        {
            _leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [_leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self addSubview:_leftButton];
            [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14);
                make.top.equalTo(self).with.offset(StatusBar_Height);//设计说的
                make.width.mas_equalTo(MIN_BUTTON);
                make.height.mas_equalTo(MIN_BUTTON);
            }];
        }
        
        [_leftButton setImage:newLeftButtonImage forState:UIControlStateNormal];
    }
    [_leftButton.imageView setTintColor:newLeftButtonColor ? newLeftButtonColor : _leftButton.imageView.tintColor];
}

-(void)setLeftButtonTitle:(NSString*)newLeftButtonTitle leftButtonTextColor:(UIColor*)newLeftButtonTextColor
{
    if (newLeftButtonTitle)
    {
        if (!_leftButton)
        {
            _leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [_leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self addSubview:_leftButton];
            
            CGFloat width = [[[NSAttributedString alloc] initWithString:newLeftButtonTitle attributes:@{NSFontAttributeName:SetFont(13)}] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MIN_BUTTON) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
            
            [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14);
                make.top.equalTo(self).with.offset(StatusBar_Height);
                make.width.mas_equalTo(width+kTextBtnPad);
                make.height.mas_equalTo(MIN_BUTTON);
            }];
            
            _leftButton.titleLabel.font = SetFont(13);
        }
        else
        {
            CGFloat width = [[[NSAttributedString alloc] initWithString:newLeftButtonTitle attributes:@{NSFontAttributeName:SetFont(13)}] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MIN_BUTTON) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
            [_leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width+kTextBtnPad);
            }];
        }
        [_leftButton setTitle:newLeftButtonTitle forState:UIControlStateNormal];
    }
    [_leftButton setTitleColor:newLeftButtonTextColor ? newLeftButtonTextColor : _leftButton.titleLabel.textColor forState:UIControlStateNormal];
}

-(void)setRightButtonImage:(UIImage *)newRightButtonImage rightButtonColor:(UIColor*)newRightButtonColor
{
    if (newRightButtonImage)
    {
        if (!_rightButton)
        {
            _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [_rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self addSubview:_rightButton];
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14);
                make.top.equalTo(self).with.offset(StatusBar_Height);
                make.width.mas_equalTo(MIN_BUTTON);
                make.height.mas_equalTo(MIN_BUTTON);
            }];

        }
        
        [_rightButton setImage:newRightButtonImage forState:UIControlStateNormal];
    }
    if (newRightButtonColor) {
           [_rightButton.imageView setTintColor:newRightButtonColor];
    }
 
}

-(void)setRightButtonTitle:(NSString *)newRightButtonTitle rightButtonTextColor:(UIColor *)newRightButtonTextColor
{
    if (newRightButtonTitle)
    {
        if (!_rightButton)
        {
            _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [_rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self addSubview:_rightButton];
            
            CGFloat width = [[[NSAttributedString alloc] initWithString:newRightButtonTitle attributes:@{NSFontAttributeName:Font14}] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MIN_BUTTON) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
            
            [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14);
                make.top.equalTo(self).with.offset(StatusBar_Height);
                make.width.mas_equalTo(width+kTextBtnPad);
                make.height.mas_equalTo(MIN_BUTTON);
            }];
            
            _rightButton.titleLabel.font = Font14;

        }
        else
        {
            CGFloat width = [[[NSAttributedString alloc] initWithString:newRightButtonTitle attributes:@{NSFontAttributeName:Font14}] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MIN_BUTTON) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
            [_rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width+kTextBtnPad);
            }];
        }
        [_rightButton setTitle:newRightButtonTitle forState:UIControlStateNormal];
    }
    [_rightButton setTitleColor:newRightButtonTextColor ? newRightButtonTextColor : _rightButton.titleLabel.textColor forState:UIControlStateNormal];
}

-(void)setTitle:(NSString *)newTitle textColor:(UIColor*)newTextColor
{
    if (newTitle)
    {
        _titleLabel.text = newTitle;
    }
    _titleLabel.textColor = newTextColor ? newTextColor : _titleLabel.textColor;
}

-(void)setHideBottomLine:(BOOL)hideBottomLine
{
    _bottomLine.hidden = hideBottomLine;
    _hideBottomLine = hideBottomLine;
}

- (void)setRightButtonEnable:(BOOL)rightButtonEnable
{
    _rightButtonEnable = rightButtonEnable;
    _rightButton.enabled = rightButtonEnable;
}

//-(void)rightFakeNaviBtnAddRedDot
//{
//    if(!_redDotLayer)
//    {
//        _redDotLayer = [[CALayer alloc] init];
//        _redDotLayer.backgroundColor = [UIColor colorWithHexString:@"#F3433F"].CGColor;
//        _redDotLayer.frame = CGRectMake(_rightButton.bounds.size.width, 10, 26, 16);
//        _redDotLayer.cornerRadius = 3;
//    }
//    [_rightButton.layer addSublayer:_redDotLayer];
//}
//
//-(void)rightFakeNaviBtnRemoveRedDot
//{
//    if (_redDotLayer)
//    {
//        [_redDotLayer removeFromSuperlayer];
//    }
//}

//-(void)rightFakeNaviBtnAddredBubbleWithNumber:(NSNumber *)number
//{
//    
//    self.redBubbleView.messageCount = number;
//    [self addSubview:self.redBubbleView];
//    
//    [self.redBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).with.offset(-3);
//        make.top.equalTo(self).with.offset(STATUSBAR_HI + 5);
//        make.width.mas_equalTo(kRedBubbleWidth);
//        make.height.mas_equalTo(kRedBubbleHeight);
//    }];
//    
//    self.redBubbleView.layer.cornerRadius = kRedBubbleHeight / 2;
//    
//}

//-(void)rightFakeNaviRemoveRedBubble
//{
//    if (self.redBubbleView)
//    {
//        [self.redBubbleView removeFromSuperview];
//    }
//}

//- (DDCRedBubbleView *)redBubbleView
//{
//    if (!_redBubbleView) {
//        _redBubbleView = [[DDCRedBubbleView alloc] initWithType:DDCRedBubbleViewTypeNormal];
//        _redBubbleView.alpha = 1;
//    }
//    return _redBubbleView;
//}

@end
