//
//  QJCOrdercell.h
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QJCOrderModel.h"
#import "QJCOrderListmodel.h"
typedef void (^jumpBlock)(NSString * orderId, BOOL pay); //pay也是支付  NO删除
@interface QJCOrdercell : UITableViewCell
@property (copy , nonatomic) jumpBlock jumpAction;
@property (strong ,nonatomic) QJCOrderListmodel * modle;

@property (weak, nonatomic) IBOutlet UILabel *OrderTitle;

@property (weak, nonatomic) IBOutlet UILabel *OrderTime;

@property (weak, nonatomic) IBOutlet UILabel *OederPrice;
@property (weak, nonatomic) IBOutlet UILabel *OrderAddress;

@property (weak, nonatomic) IBOutlet UIView *PersonShowView;

@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *PayBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)PayAction:(UIButton *)sender;






@end
