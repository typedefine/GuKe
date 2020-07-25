//
//  ZJNGradeTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2017/9/27.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNGradeTableViewCell.h"
#import "pingfensmallView.h"
#import "PingfenModel.h"
 @implementation ZJNGradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Utile makeCorner:5 view:_firstLineRightButton];
    [Utile makeCorner:5 view:_secondLineRightButton];
    [Utile makeCorner:5 view:_thirdLineRightButton];
    // Initialization code
}
//- (IBAction)firstLineButtonClick:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(gradeButtonClickWithGradeType:)]) {
//        [self.delegate gradeButtonClickWithGradeType:@"harris"];
//    }
//}
//- (IBAction)secondLineButtonClick:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(gradeButtonClickWithGradeType:)]) {
//        [self.delegate gradeButtonClickWithGradeType:@"hss"];
//    }
//}
//- (IBAction)thirdLineButtonClick:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(gradeButtonClickWithGradeType:)]) {
//        [self.delegate gradeButtonClickWithGradeType:@"sf-12"];
//    }
//}

-(void)setHarrisString:(NSString *)harrisString{
    _harrisString = harrisString;
    if (_harrisString.length == 0) {
        self.firstLineMiddleLabel.text = @"未评分";
        self.firstLineMiddleLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.firstLineMiddleLabel.text = _harrisString;
        self.firstLineMiddleLabel.textColor = SetColor(0x1a1a1a);
    }
    
}
-(void)setHSSString:(NSString *)HSSString{
    _HSSString = HSSString;
    if (_HSSString.length == 0) {
        self.secondLineMiddleLable.text = @"未评分";
        self.secondLineMiddleLable.textColor = [UIColor lightGrayColor];
    }else{
        self.secondLineMiddleLable.text = _HSSString;
        self.secondLineMiddleLable.textColor = SetColor(0x1a1a1a);
    }
}
-(void)setSF_12String:(NSString *)SF_12String{
    _SF_12String = SF_12String;
    if (_SF_12String.length == 0) {
        self.thirdLineMiddleLabel.text = @"未评分";
        self.thirdLineMiddleLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.thirdLineMiddleLabel.text = _SF_12String;
        self.thirdLineMiddleLabel.textColor = SetColor(0x1a1a1a);
    }
}

-(void)setPingfenArray:(NSMutableArray *)PingfenArray{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview] ;
    }

    _PingfenArray  = PingfenArray;
     for (int i = 0; i<PingfenArray.count;i++) {
        PingfenModel  *model = PingfenArray[i];
        pingfensmallView * view =   [[[NSBundle mainBundle]loadNibNamed:@"pingfensmallView" owner:self options:nil]lastObject];
        view.frame  = CGRectMake(0,  36*i , self.contentView.width, 36) ;
         view.model = model;
        
        
         UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
         btn.frame = CGRectMake(ScreenWidth - 79, 5 + 36*i, 63, 26);
         [btn setTitle:@"评分" forState:UIControlStateNormal];
         [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(ACtionforBtn:) forControlEvents:UIControlEventTouchUpInside];
         [btn setBackgroundColor:[UIColor colorWithHex:0x06A27B]];
         btn.titleLabel.font =[UIFont systemFontOfSize:13];
         btn.tag  = 20+i;

         
         
//        __block typeof(view) BLockView = view;
//        __weak typeof(self) weakSelf = self;
//        view.SelectBlock = ^{
//
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(gradeButtonClickWithGradeType:)]) {
//                [weakSelf.delegate gradeButtonClickWithGradeType:(int)BLockView.tag - 20];
//            }
//
//         };
        
         
         
         [self  addSubview:view];
         [self  addSubview:btn];

        
    }
    
    
}

-(void)ACtionforBtn:(UIButton *)sender{
    
                if (self.delegate && [self.delegate respondsToSelector:@selector(gradeButtonClickWithGradeType:)]) {
                    [self.delegate gradeButtonClickWithGradeType:((NSInteger)sender.tag - 20)];
                }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
