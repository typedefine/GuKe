//
//  WorkSpaceInfoCellModel.m
//  GuKe
//
//  Created by yb on 2020/11/3.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "ExpandTextCellModel.h"
#import "ZXFExpandTextViewModel.h"

@implementation ExpandTextCellModel

- (instancetype)init
{
    if (self = [super init]) {
        self.textModel = [[ZXFExpandTextViewModel alloc] init];
        self.textModel.lineNumForContraction = 5;
        self.textModel.constractTextMaxLength = 62;
    }
    return self;
}


- (BOOL)expanded
{
    return self.textModel.expanded;
}

- (void)setExpanded:(BOOL)expanded
{
    self.textModel.expanded = expanded;
}

- (NSString *)content
{
    return self.textModel.text;
}

- (void)setContent:(NSString *)content
{
    self.textModel.text = content;
}

//- (NSString *)displayContent
//{
//    if (self.content.isValidStringValue) {
//        if (self.showAll) {
//            return self.content;
//        }else{
//            
//        }
//    }
//    return @"";
//}

@end
