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
//@property (nonatomic, strong) WorkSpaceInfoModel *pageModel;

@end

@implementation WorkSpaceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作站";
    
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadServerData];
}

- (void)loadServerData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_joined_workplace];
    NSMutableDictionary *para = [@{
        @"sessionId": [GuKeCache shareCache].sessionId,
    } mutableCopy];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        [self hideHud];
        WorkSpaceInfoModel *model = [WorkSpaceInfoModel mj_objectWithKeyValues:data];
        if ([model.retcode isEqualToString:@"0000"]) {
            [self.infoView configareWithTargetController:self data:model];
        }
    } failure:^(NSError *error) {
        [self hideHud];
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
