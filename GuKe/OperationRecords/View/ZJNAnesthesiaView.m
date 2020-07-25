//
//  ZJNAnesthesiaView.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNAnesthesiaView.h"
@interface ZJNAnesthesiaView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *bgView;
    UIPickerView *pickerView;
    NSInteger selectedRow;
    UILabel *selectedLabel;
    NSString *selectedAnesthesiaUid;
    NSString *selectedAnesthesiaName;
}

@end
@implementation ZJNAnesthesiaView
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
        selectedRow = 0;
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-TabbarAddHeight-200, ScreenWidth, 200)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        for (int i = 0; i <2; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                button.frame = CGRectMake(0, 0, 80, 44);
                [button setTitle:@"取消" forState:UIControlStateNormal];
            }else{
                button.frame = CGRectMake(ScreenWidth-80, 0, 80, 44);
                [button setTitle:@"确定" forState:UIControlStateNormal];
            }
            [button setTitleColor:SetColor(0x666666) forState:UIControlStateNormal];
            button.tag = 10+i;
            [button addTarget:self action:@selector(cancelOrOKButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
        }
        
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, bgView.height-44)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [bgView addSubview:pickerView];
    }
    return self;
    
    // Do any additional setup after loading the view.
}
#pragma mark--UIPickerViewDelegate,UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return ScreenWidth;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dic = _dataArr[row];
    return dic[@"anesthesiaName"];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSDictionary *dic = self.dataArr[row];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = SetFont(14);
    titleLabel.textColor = SetColor(0x666666);
    if (row == selectedRow) {
        titleLabel.textColor = greenC;
        selectedLabel = titleLabel;
        selectedAnesthesiaUid = dic[@"uid"];
        selectedAnesthesiaName = dic[@"anesthesiaName"];
    }
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return titleLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedLabel.textColor = SetColor(0x666666);
    UILabel *titleLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    titleLabel.textColor = greenC;
    selectedLabel = titleLabel;
    selectedRow = row;
    NSDictionary *dic = self.dataArr[row];
    selectedAnesthesiaUid = dic[@"uid"];
    selectedAnesthesiaName = dic[@"anesthesiaName"];

}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [pickerView reloadAllComponents];
//    [pickerView selectRow:0 inComponent:0 animated:YES];

}
-(void)cancelOrOKButtonClick:(UIButton *)button{
    if (button.tag == 10) {
        [self removeFromSuperview];
    }else{
        if (self.selectedAnesthesia) {
            self.selectedAnesthesia(selectedAnesthesiaName,selectedAnesthesiaUid);
        }
        [self removeFromSuperview];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
