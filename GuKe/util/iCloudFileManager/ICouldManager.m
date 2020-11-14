//
//  ICouldManager.m
//  GuKe
//
//  Created by yb on 2020/10/17.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ICouldManager.h"
#import "ZXFDocument.h"

@implementation ICouldManager

+ (BOOL)iCouldEnable
{
    NSURL *url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    return url != nil;
}

+ (void)downloadFileWithDocumentUrl:(NSURL *)url completion:(FileDownloadedCompletionHandler)completion
{
    ZXFDocument *document = [[ZXFDocument alloc] initWithFileURL:url];
    [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [document closeWithCompletionHandler:nil];
            }
        if (completion) {
            completion(document.data);
        }
    }];
}

@end
