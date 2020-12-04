//
//  WorkSpaceViewModel.m
//  GuKe
//
//  Created by yb on 2020/11/29.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoViewModel.h"
#import "WorkGroupItemCellModel.h"

@implementation WorkSpaceInfoViewModel

- (void)configareWithData:(NSDictionary *)data
{
    
    self.headerImgUrl = data[@"gxsPic"];
    self.textModel.content = data[@"gxsIntro"];
    NSArray *groups = data[@"data"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:groups.count];
    for (int i=0; i<groups.count; i++) {
        NSDictionary *d = groups[i];
        WorkGroupItemCellModel *itemModel = [[WorkGroupItemCellModel alloc] init];
        itemModel.groupId = d[@"groupid"];
        itemModel.title = d[@"groupname"];
        itemModel.avatarUrl = d[@"portrait"];
        [items addObject:itemModel];
    }
    self.groups = [items copy];
    
    /*
    self.headerImgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1606041227130&di=67531d97a7bce3d235754e7eac50c9ee&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F52%2F62%2F31300542679117141195629117826.jpg";
    self.textModel.content = @"骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤";
    NSArray *ids = @[@"1", @"2"];
    NSArray *titles = @[@"大骨科工作室", @"王医生大骨科工作室"];
    NSArray *imgs = @[
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1363512782,2335530027&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3695259271,1715923868&fm=26&gp=0.jpg",
    ];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:ids.count];
    for (int i=0; i<ids.count; i++) {
        WorkGroupItemCellModel *itemModel = [[WorkGroupItemCellModel alloc] init];
        itemModel.groupId = ids[i];
        itemModel.title = titles[i];
        itemModel.avatarUrl = imgs[i];
        [items addObject:itemModel];
    }
    self.groups = [items copy];
    */
}


- (ExpandTextCellModel *)textModel
{
    if (!_textModel) {
        _textModel = [[ExpandTextCellModel alloc] init];
    }
    return _textModel;
}


@end
