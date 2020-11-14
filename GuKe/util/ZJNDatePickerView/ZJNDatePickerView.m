//
//  ZJNDatePickerView.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/20.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNDatePickerView.h"
@interface ZJNDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *yearsArr;
    NSMutableArray *monthsArr;
    NSString *year;
    NSString *month;
}
@end
@implementation ZJNDatePickerView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM"];
        NSString *dateStr = [formatter stringFromDate:currentDate];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
        year = dateArr[0];
        month = dateArr[1];
        yearsArr = [NSMutableArray array];
        monthsArr = [NSMutableArray array];
        NSInteger years = 1970;
        for (int i = 0; i <100; i ++) {
            years += 1;
            NSString *yearStr = [NSString stringWithFormat:@"%ld",years];
            [yearsArr addObject:yearStr];
        }
        NSInteger months = 0;
        for ( int i = 0; i <12; i ++) {
            months += 1;
            NSString *monthStr;
            if (i<9) {
                monthStr = [NSString stringWithFormat:@"0%ld",months];
            }else{
                monthStr = [NSString stringWithFormat:@"%ld",months];
            }
            
            [monthsArr addObject:monthStr];
        }
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * toolView = [[UIView alloc]init];
        [self addSubview:toolView];
        toolView.frame = CGRectMake(0, 0, ScreenWidth, 42);
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(ScreenWidth-18-33, 10, 33, 22);
        [toolView addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:greenC forState:UIControlStateNormal];
        [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = Font16;
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(18, 10, 33, 22);
        [toolView addSubview:_cannelBtn];
        
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:titColor forState:UIControlStateNormal];
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = Font16;
        
        UILabel * titleLab = [[UILabel alloc]init];
        [toolView addSubview:titleLab];
        titleLab.frame = CGRectMake((ScreenWidth-130)/2, 12, 130, 17);
        // titleLab.text = @"请选择申请日期";
        titleLab.font = Font16;
        titleLab.textColor = titColor;
        
        UIView * lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.frame = CGRectMake(0, 42, ScreenWidth, 0.5);
        lineView.backgroundColor = titColor;
        
        UIPickerView *datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 52, ScreenWidth, 132)];
        
        datePicker.delegate = self;
        datePicker.dataSource = self;
        [self addSubview:datePicker];
        [datePicker selectRow:[yearsArr indexOfObject:year] inComponent:0 animated:NO];
        [datePicker selectRow:[monthsArr indexOfObject:month] inComponent:1 animated:NO];
    }
    return self;
}
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    if (component == 0) {
        return yearsArr.count;
    }
    return monthsArr.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    if (component == 0) {
        return [yearsArr objectAtIndex:row];
    }
    return [monthsArr objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        year = yearsArr[row];
    }else{
        month = monthsArr[row];
    }
    NSLog(@"%@-%@",year,month);
    
}
-(void)sureBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectedDate:)]) {
        [self.delegate getSelectedDate:[NSString stringWithFormat:@"%@-%@",year,month]];
    }
}
-(void)cannelBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCenterDatePicker)]) {
        [self.delegate getCenterDatePicker];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
