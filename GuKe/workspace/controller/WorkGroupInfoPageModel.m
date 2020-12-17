//
//  WorkGroupInfoPageModel.m
//  GuKe
//
//  Created by yb on 2020/12/15.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkGroupInfoPageModel.h"

@implementation WorkGroupInfoPageModel

- (void)configareWithData:(id)data
{
    self.name = @"大骨科工作组";
    self.des = @"骨科学又称矫形外科学。医学的一个专业或学科，专门研究骨骼肌肉系统的解剖、生理与病理，运用药物、手术及物理方法保持和发展这一系统的正常形态与功能，以及治疗这一系统的伤病。";
    NSArray *titles = @[@"大骨科工作室", @"王医生大骨科工作室"];
    NSArray *imgs = @[
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1363512782,2335530027&fm=26&gp=0.jpg",
        @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3695259271,1715923868&fm=26&gp=0.jpg",
    ];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i=0; i<11; i++) {
        UserInfoModel *um = [[UserInfoModel alloc] init];
        um.doctorName = titles[i%2];
        um.portrait = imgs[i%2];
        [items addObject:um];
    }
    self.members = [items copy];
}

@end
