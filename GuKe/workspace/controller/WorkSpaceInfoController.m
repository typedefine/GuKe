//
//  WorkSpaceInfoController.m
//  GuKe
//
//  Created by yb on 2021/1/2.
//  Copyright © 2021 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoController.h"
#import "WorkSpaceInfoModel.h"
#import "WorkSpaceInfoView.h"

@interface WorkSpaceInfoController ()

@property (nonatomic, strong) WorkSpaceInfoView *infoView;

@end

@implementation WorkSpaceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作站";
    [self.infoView configareWithTargetController:self data:self.pageModel];
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (WorkSpaceInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[WorkSpaceInfoView alloc] init];
    }
    return _infoView;
}

@end
