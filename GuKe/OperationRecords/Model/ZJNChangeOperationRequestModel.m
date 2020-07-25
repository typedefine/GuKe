//
//  ZJNChangeOperationRequestModel.m
//  GuKe
//
//  Created by 朱佳男 on 2018/2/8.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "ZJNChangeOperationRequestModel.h"

@implementation ZJNChangeOperationRequestModel
-(id)initWithOperationModel:(OperationInfoModel *)model{
    self = [super init];
    if (self) {
        self.qx = [NSMutableArray array];
        self.imagex = [NSMutableArray array];
         self.sessionId = sessionIding;
        self.surgeryId = model.surgeryId;
        self.surgeryTime = model.surgeryTime;
        self.surgeryName = model.surgeryName;
        self.attr2 = model.doctor;
        self.brandName = model.brandName;
        self.brandId = model.brandId;

        self.anesthesiaId = model.anesthesiaId;
        self.anesthesiaName = model.anesthesiaName;
        self.approach = model.approach;
        self.firstzs = model.firstzs;
        self.twozs = model.twozs;
        self.brand = model.brand;
        self.video = [[NSMutableArray alloc]initWithArray:model.video];
        self.imaget = [[NSMutableArray alloc]initWithArray:model.imaget];
        NSMutableArray *imagesArr = [NSMutableArray array];
        for (int i = 0; i <model.images.count; i ++) {
            NSDictionary *dic = model.images[i];
            [imagesArr addObject:dic[@"path"]];
        }
        [self.qx addObjectsFromArray:imagesArr];
        
        NSMutableArray *imageXArr = [NSMutableArray array];
        for (int i = 0; i <model.imagex.count; i ++) {
            NSDictionary *dic = model.imagex[i];
            [imageXArr addObject:dic[@"path"]];
        }
        [self.imagex addObjectsFromArray:imageXArr];
    }
    return self;
}
@end
