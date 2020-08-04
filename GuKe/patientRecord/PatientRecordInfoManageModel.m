//
//  PatientRecordInfoManageModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientRecordInfoManageModel.h"

@implementation PatientRecordInfoSectionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.rowCount = 1;
    }
    return self;
}

@end

@implementation PatienRecordFitMentionSectionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"健康提醒";
    }
    return self;
}


@end

@implementation PatientRecordInfoManageSectionModel
@synthesize cellModelList;

- (instancetype)init
{
    if (self = [super init]) {
        cellModelList = @[];
        self.title = @"信息展示";
        NSArray *itemTitleList = @[@"就诊记录", @"手术记录", @"随访记录"];
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i<itemTitleList.count; i++) {
            PatientRecordInfoManageCellModel *cellModel = [[PatientRecordInfoManageCellModel alloc] init];
            cellModel.title = itemTitleList[i];
            [items addObject:cellModel];
        }
       cellModelList = [items copy];
        self.rowCount = cellModelList.count;
    }
    return self;
}

@end


@implementation PatientRecordBookSectionModel
@synthesize cellModelList;

- (instancetype)init
{
    if (self = [super init]) {
        cellModelList = @[];
        self.title = @"预约就诊";
    }
    return self;
}

- (void)configureWithData:(id)data
{
    NSMutableArray *bookList = [NSMutableArray array];
    PatientRecordBookCellModel *cellModel = [[PatientRecordBookCellModel alloc] init];
    cellModel.title  = @"已回复";
    cellModel.time = @"2020-08-03";
    [bookList addObject:cellModel];
    
    cellModel = [[PatientRecordBookCellModel alloc] init];
    cellModel.title  = @"未回复";
    cellModel.titleColor = [UIColor redColor];
    [bookList addObject:cellModel];
    
    cellModelList = [bookList copy];
//    self.rowCount = cellModelList.count;
}

- (NSInteger)rowCount
{
    return self.cellModelList.count;
}

@end




@implementation PatientRecordInfoManageModel

@synthesize sectionModelList;

- (instancetype)init
{
    if (self = [super init]) {
        sectionModelList = @[
            [[PatienRecordFitMentionSectionModel alloc] init],
            [[PatientRecordInfoManageSectionModel alloc] init],
            [[PatientRecordBookSectionModel alloc] init]
        ];
        self.numberOfSection = sectionModelList.count;
    }
    return self;
}

- (void)configureWithData:(id)data
{
    PatientRecordBookSectionModel *bookSectionModel =  (PatientRecordBookSectionModel *)self.sectionModelList[2];
    [bookSectionModel configureWithData:[NSNull null]];
}

- (PatientRecordInfoSectionModel *)sectionModel:(NSInteger)section
{
    return self.sectionModelList[section];
}

- (NSString *)titleForSection:(NSInteger)section
{
    return self.sectionModelList[section].title;
}

- (NSInteger)numberOfRowAtSection:(NSInteger)section
{
    return self.sectionModelList[section].rowCount;
}


- (CGSize)sizeForItemAtSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return CGSizeMake(ScreenWidth-40, 180);
        case 1:
            return CGSizeMake(ScreenWidth, 40);
            
        default:
            return CGSizeMake(ScreenWidth, 30);
    }
}

@end
