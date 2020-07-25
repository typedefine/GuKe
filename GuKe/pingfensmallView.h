//
//  pingfensmallView.h
//  GuKe
//
//  Created by MYMAc on 2018/6/11.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PingfenModel.h"
typedef void(^BlockType)();


@interface pingfensmallView : UIView


@property (weak, nonatomic) IBOutlet UILabel *PingfenNameLB;
@property (weak, nonatomic) IBOutlet UILabel *PingfenFenshuLB;
@property (weak, nonatomic) IBOutlet UIButton *PingfenBtn;
@property (strong, nonatomic) PingfenModel * model;
@property (strong, nonatomic) BlockType  SelectBlock;

- (IBAction)PingfenAction:(id)sender;

@end
