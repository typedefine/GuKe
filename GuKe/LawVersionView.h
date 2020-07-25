//
//  LawVersionView.h
//  TheLawyer
//
//  Created by MYMAc on 2018/12/26.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LawVersionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *ConcentLB;
@property (weak, nonatomic) IBOutlet UIButton *ConcentBtn;
@property (weak, nonatomic) IBOutlet UIView *WihtView;

@property (copy, nonatomic) void(^UpAction)();
- (IBAction)UPAction:(UIButton *)sender;
-(void)makeUI;
@property (weak, nonatomic) IBOutlet UILabel *VersionLB;


@end

NS_ASSUME_NONNULL_END
