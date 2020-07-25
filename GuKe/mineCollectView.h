//
//  mineCollectView.h
//  GuKe
//
//  Created by MYMAc on 2018/3/23.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopViewSelectDelegate <NSObject>
-(void)selectItemWithIndex:(NSInteger )index;
@end

@interface mineCollectView : UIView
@property( nonatomic,weak) id<TopViewSelectDelegate> delegate;


-(void)makeSelectItemWihtIndex:(NSInteger)index;
@end
