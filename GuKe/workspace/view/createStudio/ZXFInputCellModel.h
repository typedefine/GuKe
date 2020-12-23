//
//  ZXFInputCellModel.h
//  GuKe
//
//  Created by saas on 2020/12/23.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZXFInputCellType){
    ZXFInputCellTypeTextField,
    ZXFInputCellTypeImagePick,
    ZXFInputCellTypeTextView
};

@interface ZXFInputCellModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, assign) ZXFInputCellType cellType;

@end

NS_ASSUME_NONNULL_END
