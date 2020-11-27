//
//  WorkSpaceInfoCellModel.h
//  GuKe
//
//  Created by yb on 2020/11/3.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZXFExpandTextViewModel;
@interface ExpandTextCellModel : NSObject

@property (nonatomic, copy) NSString *imgUrl;
//@property (nonatomic, copy) NSString *displayContent;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong) ZXFExpandTextViewModel *textModel;

@end

NS_ASSUME_NONNULL_END
