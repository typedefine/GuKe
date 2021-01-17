//
//  OnScreenCommentsView.h
//  GuKe
//
//  Created by yb on 2021/1/7.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnScreenCommentsView : UIView

- (void)configWithData:(id)data;
- (void)configWithType:(NSInteger)type conttent:(NSString *)content sendUser:(UserInfoModel *)user;

- (void)pause;
- (void)resume;
- (void)clean;

@end

NS_ASSUME_NONNULL_END
