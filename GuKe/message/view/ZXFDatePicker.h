//
//  ReplyMedicalBookAlert.h
//  GuKe
//
//  Created by 莹宝 on 2020/9/1.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZXFDatePickerDelegate;

@interface ZXFDatePicker : UIView

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, strong, readonly) NSDate *selectedDate;

@property (nonatomic, weak) id<ZXFDatePickerDelegate> delegate;

- (void)showWithSelectedDate:(NSDate *)date;
- (void)show;
- (void)dismiss;
- (void)resetDate;

@end

@protocol ZXFDatePickerDelegate <NSObject>

@optional

- (void)pickerView:(ZXFDatePicker *)pickerView didSelectWithselectedDate:(NSDate *)date;

- (void)pickerView:(ZXFDatePicker *)pickerView didCancelWithselectedDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
