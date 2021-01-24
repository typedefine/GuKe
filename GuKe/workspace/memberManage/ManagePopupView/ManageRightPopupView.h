//
//  ManageRightPopupView.h
//

#import <UIKit/UIKit.h>
@class ManageRightPopupCellModel, ManageRightPopupView;

NS_ASSUME_NONNULL_BEGIN

@protocol ManageRightPopupViewDelegate <NSObject>

@required
- (NSArray<ManageRightPopupCellModel *> *)itemsForPopupView:(ManageRightPopupView *)popupView;

@optional
- (void)popupView:(ManageRightPopupView *)popupView didSelectAtIndx:(NSUInteger)index;

@end

@interface ManageRightPopupView : UIView

@property(nonatomic, assign, readonly) bool isShow;
@property (nonatomic) id extra;

- (instancetype)initWithDelegate:(id<ManageRightPopupViewDelegate>)delegate;

- (void)show;
- (void)diss;

@end

NS_ASSUME_NONNULL_END
