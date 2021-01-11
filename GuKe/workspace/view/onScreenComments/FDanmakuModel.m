//
//  FDanmakuModel.m
//  FDanmakuDemo
//
//  Created by allison on 2018/5/21.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "FDanmakuModel.h"
#import "FDanmakuModelProtocol.h"

@implementation FDanmakuModel

- (void)setModel:(DMModel *)model
{
    _model = model;
    if (model.isValidObjectValue) {
        self.name = model.doctorName;
        self.content = model.content;
        self.type = model.msgType;
    }
}

@end
