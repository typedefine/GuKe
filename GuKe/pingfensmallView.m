//
//  pingfensmallView.m
//  GuKe
//
//  Created by MYMAc on 2018/6/11.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "pingfensmallView.h"

@implementation pingfensmallView
-(void)setModel:(PingfenModel *)model{
    _model = model;
    self.PingfenNameLB.text = model.formName;
    if (model.saveNumber.length > 0 ) {
        self.PingfenFenshuLB.text = model.saveNumber;
        self.PingfenFenshuLB.textColor = SetColor(0x1a1a1a);

    }else{
        self.PingfenFenshuLB.text = @"未评分";
        self.PingfenFenshuLB.textColor = [UIColor lightGrayColor];
    }
    
    
 
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)PingfenAction:(id)sender {
    NSLog(@"1234567890-");
    self.SelectBlock();
}
@end
