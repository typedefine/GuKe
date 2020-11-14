//
//  ICouldManager.h
//  GuKe
//
//  Created by yb on 2020/10/17.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ FileDownloadedCompletionHandler)(NSData *data);

@interface ICouldManager : NSObject

+ (BOOL)iCouldEnable;

+ (void)downloadFileWithDocumentUrl:(NSURL *)url completion:(FileDownloadedCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
