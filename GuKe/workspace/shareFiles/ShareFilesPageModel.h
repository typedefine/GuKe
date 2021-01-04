//
//  ShareFilesPageModel.h
//  GuKe
//
//  Created by yb on 2021/1/5.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareFileItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShareFilesPageModel : NSObject

@property (nonatomic, strong) NSArray<ShareFileItemModel *> *items;

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger curPage;

@end

NS_ASSUME_NONNULL_END
