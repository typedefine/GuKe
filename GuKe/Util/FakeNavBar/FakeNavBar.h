//
//  FakeNavBar.h
//  DayDayCook
//
//  Created by Christopher Wood on 8/19/16.
//  Copyright © 2016 GFeng. All rights reserved.
//

typedef NS_ENUM(NSUInteger, HiddenType) {
    HiddenTypeAllHidden,
    HiddenTypeTitleHidden,
    HiddenTypeLeftButtonAndTitleHidden,
    HiddenTypeRightButtonAndTitleHidden,
    HiddenTypeAllButtonsHidden,
    HiddenTypeBottomLine
};

@protocol FakeNavBarDelegate

@optional
-(void)didTapLeftBarButton;
-(void)didTapRightBarButton;

@end

@interface FakeNavBar : UIView

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString*)title
                   textColor:(UIColor*)textColor
             leftButtonImage:(UIImage*)leftButtonImage
        leftButtonImageColor:(UIColor*)leftButtonImageColor
            rightButtonImage:(UIImage*)rightButtonImage
       rightButtonImageColor:(UIColor*)rightButtonImageColor
                    delegate:(id<FakeNavBarDelegate>)delegate;

-(void)setLeftButtonImage:(UIImage *)newLeftButtonImage leftButtonColor:(UIColor*)newLeftButtonColor;
-(void)setLeftButtonTitle:(NSString*)newLeftButtonTitle leftButtonTextColor:(UIColor*)newLeftButtonTextColor;
-(void)setRightButtonImage:(UIImage *)newRightButtonImage rightButtonColor:(UIColor*)newRightButtonColor;
-(void)setRightButtonTitle:(NSString*)newRightButtonTitle rightButtonTextColor:(UIColor*)newRightButtonTextColor;
-(void)setTitle:(NSString*)newTitle textColor:(UIColor*)textColor;

// 默认为HiddenTypeAllHidden
@property (nonatomic, assign) HiddenType hiddenType;
@property (nonatomic, weak) id<FakeNavBarDelegate> delegate;

// 因为系统需要用isHidden和hidden，所以我们用这个hiding属性。hiding表示有没有用过hiddenType的hiding（可能只有title或leftButton被影藏了)。isHidden和hidden都表示整个navbar是否hidden
@property (nonatomic, readonly, assign) BOOL hiding;

@property (nonatomic, assign) BOOL hideBottomLine;

@property (nonatomic, assign) BOOL rightButtonEnable;

//-(void)rightFakeNaviBtnAddRedDot;
//
//-(void)rightFakeNaviBtnRemoveRedDot;
//
//-(void)rightFakeNaviBtnAddredBubbleWithNumber:(NSNumber *)number;

//-(void)rightFakeNaviRemoveRedBubble;

@end
