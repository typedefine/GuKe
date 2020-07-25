//
//  SuiFangJiLuTableViewCell.m
//  GuKe
//
//  Created by yu on 2017/8/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "SuiFangJiLuTableViewCell.h"

@implementation SuiFangJiLuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.viewOne.layer.masksToBounds = YES;
    self.viewOne.layer.cornerRadius = 4.5;
    
    self.viewTwo.layer.masksToBounds = YES;
    self.viewTwo.layer.cornerRadius = 4.5;
    
    self.viewThree.layer.masksToBounds = YES;
    self.viewThree.layer.cornerRadius = 4.5;
    
    self.viewFour.layer.masksToBounds = YES;
    self.viewFour.layer.cornerRadius = 4.5;
    
    

}
-(void)setCellWithdic:(NSDictionary *)dic{
    
    NSLog(@"forms = %@",dic[@"forms"]);
  
    
    for (int i = 0 ; i < ([dic[@"forms"] count] +1) ;i++) {
        UIView * GreeView =[[UIView alloc]init];
        UILabel *containLB = [[UILabel alloc]init];
        containLB.textColor =[UIColor colorWithHex:0x333333];

        if (i%2 == 0) {
            GreeView.frame = CGRectMake(10 , 43+  22 * floor((i+1)/2) +3, 9, 9);
            containLB.frame = CGRectMake(GreeView.right + 6, 43+  22 * floor((i+1)/2), self.width/2 - 25, 15);

        }else{
            GreeView.frame = CGRectMake(self.width/2 + 10,  43+  22 * floor((i/2)) +3, 9, 9);
            containLB.frame = CGRectMake(GreeView.right + 6, 43+  22 * floor((i)/2) , self.width/2 - 25, 15);

        }
        if (i == [dic[@"forms"] count]) {
            containLB.text = [NSString stringWithFormat:@"影像学检查:%@",[dic objectForKey:@"imagingName"]];
            
 
         }else{
            NSString* containLBstr = [NSString stringWithFormat:@"%@: %@分",[dic[@"forms"][i] objectForKey:@"formName"],[dic[@"forms"][i] objectForKey:@"saveNumber"] ];
            
             NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:containLBstr];
             NSRange range1 = [[str string] rangeOfString:[NSString stringWithFormat:@"%@分",[dic[@"forms"][i] objectForKey:@"saveNumber"]]];
             [str addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithHex:0x06A27B] range:range1];
             
             containLB.attributedText = str;
        }
        
        GreeView.backgroundColor=  [UIColor colorWithHex:0x06A27B];
        GreeView.layer.masksToBounds = YES;
        GreeView.layer.cornerRadius = 4.5;
        
        containLB.font =[UIFont systemFontOfSize:12];
        [self addSubview:GreeView];
        [self addSubview:containLB];
        
    }
    
//    self.harrisPingfenLab.text = [NSString stringWithFormat:@"Harris评分(髋关节):%@分",[dic objectForKey:@"harris"]];
//    self.hssPingFen.text = [NSString stringWithFormat:@"HSS评分(膝关节):%@分",[dic objectForKey:@"hss"]];
//    self.sfPingFenLab.text = [NSString stringWithFormat:@"SF-12评分(膝关节):%@",[dic objectForKey:@"sf"]];
    
    
    
//    self.yingxiangxueLab.text = [NSString stringWithFormat:@"影像学检查:%@",[dic objectForKey:@"imagingName"]];

    
    
    
    self.jianchaLab.text = [NSString stringWithFormat:@"专科检查：%@",[dic objectForKey:@"checks"]];
    self.timelab.text = [NSString stringWithFormat:@"回访：%@",[dic objectForKey:@"createTime"]];
    self.nameLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"patientName"]];
    self.suifangTimeLab.text = [NSString stringWithFormat:@"%@随访",[dic objectForKey:@"compareTime"]];


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
