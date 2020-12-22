//
//  WorkGroupInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/11/24.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkStudioInfoPageModel.h"

@implementation WorkStudioInfoPageModel

- (instancetype)init
{
    if (self = [super init]) {
        _name = @"";
        _logoUrl = @"";
        _members = @[];
    }
    return self;
}

- (void)configareWithData:(NSDictionary *)data
{
    _model = [GroupInfoModel mj_objectWithKeyValues:data];
    self.name = self.model.groupname;
    self.logoUrl = self.model.portrait; //@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1606041227130&di=67531d97a7bce3d235754e7eac50c9ee&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F52%2F62%2F31300542679117141195629117826.jpg";
    self.infoCellModel.content = self.model.desc; //@"骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤";
//    NSArray *titles = @[@"大骨科工作室", @"王医生大骨科工作室"];
//    NSArray *imgs = @[
//        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1363512782,2335530027&fm=26&gp=0.jpg",
//        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3695259271,1715923868&fm=26&gp=0.jpg",
//    ];
//    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
//    for (int i=0; i<11; i++) {
//        UserInfoModel *um = [[UserInfoModel alloc] init];
//        um.doctorName = titles[i%2];
//        um.portrait = imgs[i%2];
//        [items addObject:um];
//    }
    self.members = self.model.members;//[items copy];
}

- (ExpandTextCellModel *)infoCellModel
{
    if (!_infoCellModel) {
        _infoCellModel = [[ExpandTextCellModel alloc] init];
    }
    return _infoCellModel;
}

- (GroupInfoModel *)model
{
    if (!_model) {
        _model = [[GroupInfoModel alloc] init];
    }
    return _model;
}

@end
