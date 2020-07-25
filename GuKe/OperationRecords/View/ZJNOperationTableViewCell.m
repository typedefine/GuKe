//
//  ZJNOperationTableViewCell.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNOperationTableViewCell.h"

@implementation ZJNOperationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.doctorNameLabel];
        [self.contentView addSubview:self.operationTimeLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.approachLabel];
        [self.contentView addSubview:self.operationNameLabel];
        [self.contentView addSubview:self.brandLabel];
        [self.contentView addSubview:self.scrol];
        [self.contentView addSubview:self.firstLabel];
        [self.contentView addSubview:self.secondLabel];
        
        [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/2.0-20, 20));
        }];
        [self.operationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.doctorNameLabel.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.doctorNameLabel);
            make.height.equalTo(@20);
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.doctorNameLabel);
            make.top.equalTo(self.doctorNameLabel.mas_bottom).offset(5.5);
            make.height.equalTo(@35);
            make.width.equalTo(self.doctorNameLabel.mas_width);
        }];
        [self.approachLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.operationTimeLabel);
            make.height.equalTo(self.typeLabel.mas_height);
            make.top.equalTo(self.typeLabel);
        }];
 
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.doctorNameLabel);
                        make.top.equalTo(self.typeLabel.mas_bottom).offset(5.5);
                        make.right.equalTo(self.contentView).offset(-10);
                        make.height.equalTo(@20);
        }];
        
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.approachLabel);
                    make.top.equalTo(self.approachLabel.mas_bottom).offset(5.5);
                    make.right.equalTo(self.contentView).offset(-10);
                    make.height.equalTo(@20);
                }];
        
        [self.operationNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.firstLabel);
            make.height.equalTo(@35);
            make.top.equalTo(self.firstLabel.mas_bottom).offset(6);
        }];
 

        [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operationNameLabel);
            make.width.equalTo(@75);
            make.top.equalTo(self.operationNameLabel.mas_bottom).offset(6);
            make.height.equalTo(@20);
        }];
        [self.scrol mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.brandLabel.mas_right).offset(0);
            make.centerY.equalTo(self.brandLabel.mas_centerY);
            make.right.equalTo(self.secondLabel.mas_right);
            make.height.equalTo(@44);
            
        }];
    }
    return self;
}
-(UILabel *)doctorNameLabel{
    if (!_doctorNameLabel) {
        _doctorNameLabel = [[UILabel alloc]init];
        _doctorNameLabel.font = SetFont(14);
        _doctorNameLabel.textColor = SetColor(0x1a1a1a);
    }
    return _doctorNameLabel;
}
-(UILabel *)operationTimeLabel{
    if (!_operationTimeLabel) {
        _operationTimeLabel = [[UILabel alloc]init];
        _operationTimeLabel.font = SetFont(14);
        _operationTimeLabel.textColor = SetColor(0x1a1a1a);
    }
    return _operationTimeLabel;
}
-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = SetFont(14);
        _typeLabel.numberOfLines = 2;
        _typeLabel.textColor = SetColor(0x1a1a1a);
    }
    return _typeLabel;
}
-(UILabel *)approachLabel{
    if (!_approachLabel) {
        _approachLabel = [[UILabel alloc]init];
        _approachLabel.font = SetFont(14);
        _approachLabel.textColor = SetColor(0x1a1a1a);
    }
    return _approachLabel;
}
-(UILabel *)operationNameLabel{
    if (!_operationNameLabel) {
        _operationNameLabel = [[UILabel alloc]init];
        _operationNameLabel.font = SetFont(14);
        _operationNameLabel.numberOfLines = 2;
        _operationNameLabel.textColor = SetColor(0x1a1a1a);
    }
    return _operationNameLabel;
}
-(UILabel *)brandLabel{
    if (!_brandLabel) {
        _brandLabel =[[UILabel alloc]init];
        _brandLabel.font = SetFont(14);
        _brandLabel.textColor = SetColor(0x1a1a1a);
    }
    
    return _brandLabel;
}

-(UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc]init];
        _firstLabel.font = SetFont(14);
        _firstLabel.textColor = SetColor(0x1a1a1a);
    }
    return _firstLabel;
}
-(UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc]init];
        _secondLabel.font = SetFont(14);
        _secondLabel.textColor = SetColor(0x1a1a1a);
    }
    return _secondLabel;
}
-(UIScrollView *)scrol{
    if (!_scrol) {
        self.scrol = [[UIScrollView alloc]initWithFrame:CGRectMake(80, 0, ScreenWidth - 120, 44)];
        self.scrol.delegate = self;
    }
    return _scrol;
}
-(void)setModel:(OperationInfoModel *)model{
    _model = model;
    
    self.doctorNameLabel.text = [NSString stringWithFormat:@"手术医生：%@",self.model.doctor];
    [Utile setUILabel:self.doctorNameLabel data:@"手术医生：" setData:self.model.doctor color:SetColor(0x666666) font:14 underLine:NO];
    
    self.operationTimeLabel.text = [NSString stringWithFormat:@"手术时间：%@",self.model.surgeryTime];
    [Utile setUILabel:self.operationTimeLabel data:@"手术时间：" setData:self.model.surgeryTime color:SetColor(0x666666) font:14 underLine:NO];
    
    self.typeLabel.text = [NSString stringWithFormat:@"麻醉方式：%@",self.model.anesthesiaName];
    [Utile setUILabel:self.typeLabel data:@"麻醉方式：" setData:self.model.anesthesiaName color:SetColor(0x666666) font:14 underLine:NO];
    
    self.approachLabel.text = [NSString stringWithFormat:@"手术入路：%@",self.model.approach];
    [Utile setUILabel:self.approachLabel data:@"手术入路：" setData:self.model.approach color:SetColor(0x666666) font:14 underLine:NO];
    
    self.operationNameLabel.text = [NSString stringWithFormat:@"手术名称：%@",self.model.surgeryName];
    [Utile setUILabel:self.operationNameLabel data:@"手术名称：" setData:self.model.surgeryName color:SetColor(0x666666) font:14 underLine:NO];
    
    self.brandLabel.text =[NSString stringWithFormat:@"器械品牌：%@",self.model.brandName];
    self.firstLabel.text = [NSString stringWithFormat:@"第一助手：%@",self.model.firstzs];
    [Utile setUILabel:self.firstLabel data:@"第一助手：" setData:self.model.firstzs color:SetColor(0x666666) font:14 underLine:NO];
    self.secondLabel.text = [NSString stringWithFormat:@"第二助手：%@",self.model.twozs];
    [Utile setUILabel:self.secondLabel data:@"第二助手：" setData:self.model.twozs color:SetColor(0x666666) font:14 underLine:NO];
    
    NSArray * chaungchangArr =  self.model.brand;
    [self.scrol removeAllSubviews];
     for (int a = 0; a  < chaungchangArr.count; a ++) {
        UILabel *guanLab = [[UILabel alloc]initWithFrame:CGRectMake(0 + 80 * a, 12, 70, 20)];
        guanLab.text = [NSString stringWithFormat:@"%@",chaungchangArr[a][@"brandCompany"]];
        guanLab.textColor = detailTextColor;
        guanLab.backgroundColor = SetColor(0xf0f0f0);
        guanLab.layer.masksToBounds = YES;
        guanLab.layer.cornerRadius = 2;
        guanLab.font = [UIFont systemFontOfSize:13];
        guanLab.textAlignment = NSTextAlignmentCenter;
        [self.scrol addSubview:guanLab];
    }
    self.scrol.contentSize = CGSizeMake((70 + 10)* chaungchangArr.count,0);
    self.scrol.pagingEnabled = YES;

    
//    if (IS_IPHONE_5) {
//        if (chaungchangArr.count > 3) {
//            self.scrol.frame = CGRectMake(80, 0, ScreenWidth - 120, 44);
//        }else{
//            self.scrol.frame = CGRectMake(ScreenWidth - 5 - (60 + 20)* chaungchangArr.count - 20, 0, (60 + 20)* chaungchangArr.count - 20, 44);
//        }
//        self.scrol.contentSize = CGSizeMake((60 + 20)* chaungchangArr.count- 20,0);
//        self.scrol.pagingEnabled = YES;
//
//    }else{
//        if (chaungchangArr.count  > 4) {
//            self.scrol.frame = CGRectMake(80, 0, ScreenWidth - 120, 44);
//        }else{
//            self.scrol.frame = CGRectMake(ScreenWidth - 5 - (60 + 20)* chaungchangArr.count - 20, 0, (60 + 20)* chaungchangArr.count - 20, 44);
//        }
//        self.scrol.contentSize = CGSizeMake((60 + 20)* chaungchangArr.count- 20,0);
//        self.scrol.pagingEnabled = YES;
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
