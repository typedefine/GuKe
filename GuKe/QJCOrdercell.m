//
//  QJCOrdercell.m
//  singdemo
//
//  Created by MYMAc on 2018/8/6.
//  Copyright © 2018年 ShangYu. All rights reserved.
//

#import "QJCOrdercell.h"

@implementation QJCOrdercell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Utile makeCorner:5 view:self.PayBtn];
    [Utile makeCorner:5 view:self.deleteBtn];
}

-(void)setModle:(QJCOrderListmodel *)modle{
    _modle = modle;
    //    state订单状态 1未支付（下方应有前往支付的按钮，地址以后更新）2已支付3已使用4未使用（判断giveSate是否为1，如为1则下方增加转增按钮，接口以后更新）5逾期6赠送
    self.PayBtn.hidden = YES;
    self.deleteBtn.hidden = YES;
    self.TypeLabel.textColor =[UIColor colorWithHex:0x333333];

    if ([_modle.state isEqualToString:@"1"]) {
        self.TypeLabel.text = @"待支付";
        self.TypeLabel.textColor =[UIColor colorWithHex:0xff8a00];

        self.deleteBtn.hidden = NO;
        self.PayBtn.hidden = NO;
        [self.PayBtn setTitle:@"支付" forState:UIControlStateNormal];
    } else if ([_modle.state isEqualToString:@"2"]) {
        self.TypeLabel.text = @"已支付";
        self.TypeLabel.textColor  = greenC;
    }else if ([_modle.state isEqualToString:@"3"]) {
        self.TypeLabel.text = @"已使用";
        self.TypeLabel.textColor =[UIColor colorWithHex:0xf0543b];

    }else if ([_modle.state isEqualToString:@"4"]) {
        self.TypeLabel.text = @"未使用";
        self.TypeLabel.textColor =[UIColor colorWithHex:0x06a07c];
        if ([_modle.giveSate isEqualToString:@"1"]) {
            self.PayBtn.hidden = NO;
            [self.PayBtn setTitle:@"转赠" forState:UIControlStateNormal];
        }
    }else if ([_modle.state isEqualToString:@"5"]) {
        self.TypeLabel.text = @"逾期";
        self.TypeLabel.textColor =[UIColor colorWithHex:0xeabd2e];

    }else if ([_modle.state isEqualToString:@"6"]) {
        self.TypeLabel.textColor =[UIColor colorWithHex:0x139e44];

        self.TypeLabel.text = @"赠送";
    }else if ([_modle.state isEqualToString:@"7"]) {
        self.TypeLabel.text = @"已赠送";
    }
    
    
    self.OrderTitle.text = _modle.meetingName;
    self.OrderTime.text = [NSString stringWithFormat:@"时间:%@",_modle.meetTime];
    self.OederPrice.text = [NSString stringWithFormat:@"费用:%@元/人",_modle.meetPrice];
    self.OrderAddress.text = [NSString stringWithFormat:@"地点:%@",_modle.meetSite];
    
    [self.PersonShowView removeAllSubviews];
    for (int i  = 0; i< _modle.userList.count ; i++){
        
        QJCOrderModel * personModel  =  _modle.userList[i];
        UILabel * titleLB  =[[UILabel alloc]initWithFrame:CGRectMake(0,  5 + 25 * i, 100, 25)];
        titleLB.text = personModel.orderUserName;
        [self.PersonShowView addSubview:titleLB];
        
        UILabel * phoneLB  = [[UILabel alloc]initWithFrame:CGRectMake(10, 5 +  25 * i, 100, 25)];
        phoneLB.centerX = self.PersonShowView.centerX;
        phoneLB.text = personModel.orderUserPhone;
        UILabel * numberLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5 +  25 * i, 100, 25)];
        numberLb.left = self.PersonShowView.width - numberLb.width;
        numberLb.text = personModel.orderCode;
        titleLB.font =[UIFont systemFontOfSize:13];
        phoneLB.font =[UIFont systemFontOfSize:13];
        numberLb.font =[UIFont systemFontOfSize:13];
        
        [self.PersonShowView addSubview:titleLB];
        [self.PersonShowView addSubview:phoneLB];
        [self.PersonShowView addSubview:numberLb];
        //        if(i != _modle.userList.count -1 ){
        UIView * lineView  =[[UIView alloc]initWithFrame:CGRectMake(0, numberLb.bottom - 1, self.PersonShowView.width, 1)];
        lineView.backgroundColor = [UIColor colorWithHex:0xececec];
        [self.PersonShowView addSubview:lineView];
        
        //        }
        
        
    }
    
    
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (IBAction)PayAction:(UIButton *)sender {
    if(sender.tag ==31){
    if(self.jumpAction){
//         支付
         self.jumpAction(self.modle.orderNumber,YES);
    }
    }else{
//       删除
        if(self.jumpAction){
            self.jumpAction(self.modle.orderNumber,NO);
        }

    }
}
@end
