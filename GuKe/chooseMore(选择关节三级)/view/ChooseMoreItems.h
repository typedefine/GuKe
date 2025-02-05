//
//  ChooseMoreItems.h
//  ScreeningMoreTag
//
//  Created by 韩新辉 on 2017/12/24.
//  Copyright © 2017年 韩新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMoreItems : UIView

@property (nonatomic ,strong) NSMutableArray * selectedModelArray;/**<选中具体数据*/
@property (copy, nonatomic) void(^didRemoveFromSuperViewHandle)();/**<点击背景*/
@property (copy, nonatomic) void(^didSelectItemHandle)(NSString *titString);//点击事件的回调方法
@property (copy, nonatomic) void(^didSelectItem)(NSArray *SelectModelArray);//点击事件的回调方法
-(void)makeViewWithData:(NSArray *)dataArray AndSelectArray:(NSArray *)SeletArray;

@end
