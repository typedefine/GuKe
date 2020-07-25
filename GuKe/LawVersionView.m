//
//  LawVersionView.m
//  TheLawyer
//
//  Created by MYMAc on 2018/12/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "LawVersionView.h"

@implementation LawVersionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)makeUI{
    
    [Utile makeCorner:23 view: self.ConcentBtn ];
    
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.WihtView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.WihtView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.WihtView.layer.mask = maskLayer;
  
}


- (IBAction)UPAction:(UIButton *)sender {
    
    if(self.UpAction){
        self.UpAction();
        
    }
}
@end
