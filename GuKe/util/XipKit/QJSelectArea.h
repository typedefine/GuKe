//
//  QJSelectArea.h
//  Lawyer
//
//  Created by MYMAc on 2017/4/13.
//  Copyright © 2017年 ShangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJSelectArea : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
  
    NSArray * FirstDataArray;
    NSArray * SecondDataArray;
    NSArray * ThirdDataArray;
    
    
}
@property (nonatomic ,strong)  UIPickerView * selectAreaPick;


//  IsCertain   YES   确定按钮  并传地区  NO 取消不传地区

typedef void(^blockl)(BOOL IsCertain,NSString *dateString  ,NSString * prvId,NSString *cityId,NSString * AreaId) ;

-(void)ShowAreaPicker;
@property(nonatomic, strong) blockl CertainBlock;
-(void)makeDatawithArray:(NSArray *)Array ;


@end
