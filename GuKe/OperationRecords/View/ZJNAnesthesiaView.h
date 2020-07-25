//
//  ZJNAnesthesiaView.h
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNAnesthesiaView : UIView
@property (nonatomic ,strong)NSArray *dataArr;
@property (nonatomic ,copy)void(^selectedAnesthesia)(NSString *anesthesiaName,NSString *anesthesiaUid);
@end
