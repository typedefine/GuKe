//
//  uploadModel.h
//  GuKe
//
//  Created by yu on 2017/8/10.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface uploadModel : NSObject
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL      isUploaded;
@end
