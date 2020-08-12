//
//  PatientRecordInfoManageModel.m
//  GuKe
//
//  Created by 莹宝 on 2020/8/2.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "PatientInfoManagePageModel.h"
#import "PatientInfoManageModel.h"
#import "PatientBookInfoStateModel.h"

@implementation PatientRecordInfoSectionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.rowCount = 1;
    }
    return self;
}

@end

@implementation PatienFitMentionSectionModel

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"健康提醒";
    }
    return self;
}


@end

@implementation PatientInfoManageSectionModel
@synthesize cellModelList;

- (instancetype)init
{
    if (self = [super init]) {
        cellModelList = @[];
        self.title = @"信息展示";
        NSArray *itemTitleList = @[@"就诊记录", @"手术记录", @"随访记录"];
        NSMutableArray *items = [NSMutableArray array];
        for (int i=0; i<itemTitleList.count; i++) {
            PatientInfoManageCellModel *cellModel = [[PatientInfoManageCellModel alloc] init];
            cellModel.title = itemTitleList[i];
            [items addObject:cellModel];
        }
       cellModelList = [items copy];
        self.rowCount = cellModelList.count;
    }
    return self;
}



@end


@implementation PatientBookSectionModel
@synthesize cellModelList;

- (instancetype)init
{
    if (self = [super init]) {
        cellModelList = @[];
        self.title = @"预约就诊";
    }
    return self;
}

- (void)configureWithData:(NSArray<PatientBookInfoStateModel *> *)data
{
    NSMutableArray *bookList = [NSMutableArray array];
    for (PatientBookInfoStateModel *model in data) {
        PatientBookInfoStateCellModel *cellModel = [[PatientBookInfoStateCellModel alloc] init];
        if (model.isreply.isValidStringValue && [model.isreply isEqualToString:@"1"]) {
            cellModel.title  = @"已回复";
            cellModel.time = [Tools dateFormatterWithDateStringValue:model.replyTime];
        }else{
            cellModel.title  = @"未回复";
            cellModel.titleColor = [UIColor redColor];
        }
        [bookList addObject:cellModel];
    }
    cellModelList = [bookList copy];
//    self.rowCount = cellModelList.count;
}

- (NSInteger)rowCount
{
    return self.cellModelList.count;
}

@end




@implementation PatientInfoManagePageModel

@synthesize sectionModelList;

- (instancetype)init
{
    if (self = [super init]) {
        sectionModelList = @[
            [[PatienFitMentionSectionModel alloc] init],
            [[PatientInfoManageSectionModel alloc] init],
            [[PatientBookSectionModel alloc] init]
        ];
        self.numberOfSection = sectionModelList.count;
    }
    return self;
}

- (void)configureWithData:(id)data
{
    PatientInfoManageModel *model = [PatientInfoManageModel mj_objectWithKeyValues:data];
    PatienFitMentionSectionModel *fitMentionSectionModel =  (PatienFitMentionSectionModel *)[self sectionModel:0];
    if (model.remind.isValidStringValue) {
        fitMentionSectionModel.content = model.remind;
    }
    
    
    PatientInfoManageSectionModel *infoManageSectionModel =  (PatientInfoManageSectionModel *)[self sectionModel:1];
    if (model.visit.isValidStringValue) {
        infoManageSectionModel.cellModelList[0].select = [model.visit isEqualToString:@"1"];
    }
    
    if (model.operation.isValidStringValue) {
        infoManageSectionModel.cellModelList[1].select = [model.operation isEqualToString:@"1"];
    }
    
    if (model.follow.isValidStringValue) {
        infoManageSectionModel.cellModelList[2].select = [model.follow isEqualToString:@"1"];
    }
    
    PatientBookSectionModel *bookSectionModel =  (PatientBookSectionModel *)[self sectionModel:2];
    [bookSectionModel configureWithData:model.bookInfoStateList];
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
            return CGSizeMake(ScreenWidth, 180);
        case 1:
            return CGSizeMake(ScreenWidth, 40);
            
        default:
            return CGSizeMake(ScreenWidth, 30);
    }
}

@end
