//
//  QjcBackSelectView.h
//  GuKe
//
//  Created by MYMAc on 2018/5/11.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backSelectDelegate <NSObject>

-(void)selectItemWithIndex:(NSInteger)index;

@end

@interface QjcBackSelectView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong) NSArray *DataArray;
@property(weak , nonatomic) id  <backSelectDelegate> delegate ;
@end
