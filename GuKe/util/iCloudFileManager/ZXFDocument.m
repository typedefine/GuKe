//
//  ZXFDocument.m
//  GuKe
//
//  Created by yb on 2020/10/17.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ZXFDocument.h"

@implementation ZXFDocument

//- (instancetype)init
//{
//    if (self = [super init]) {
//        _data = [[NSData alloc] init];
//    }
//    return self;
//}

- (NSData *)data
{
    if (!_data) {
        _data = [[NSData alloc] init];
    }
    return _data;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing  _Nullable *)outError
{
    self.data = (NSData *)contents;
    return YES;//[super loadFromContents:contents ofType:typeName error:outError];
}

@end
