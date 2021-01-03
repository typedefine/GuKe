//
//  WorkGroupsInfoController.m
//  GuKe
//
//  Created by yb on 2020/11/1.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceController.h"
#import "WorkSpaceInfoPageModel.h"
#import "WorkSpaceInfoView.h"
#import "WorkGroupListView.h"
#import "WorkSpaceBlankView.h"
//#import "AllStudiosController.h"
//#import "CreateWordStudioController.h"
#import "WorkSpaceInfoController.h"

@interface WorkSpaceController ()

@property (nonatomic, strong) UIButton *naviRightButton;

@property (nonatomic, strong) WorkSpaceInfoPageModel *pageModel;
@property (nonatomic, strong) WorkSpaceInfoView *infoView;
@property (nonatomic, strong) WorkGroupListView *groupListView;
@property (nonatomic, strong) WorkSpaceBlankView *blankView;

@end

@implementation WorkSpaceController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.pageModel.model.groups.count == 0) {
        [self loadServerData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];

//    [self loadServerData];
}

- (void)setupUI
{
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3C3E3D]};
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x3C3E3D];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工作站";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
    [self.naviRightButton addTarget:self action:@selector(naviRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.naviRightButton.hidden = YES;
    
//    [self.view addSubview:self.infoView];
//    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    self.infoView.hidden = YES;
}

- (void)naviRightButtonAction
{
    WorkSpaceInfoController *vc = [[WorkSpaceInfoController alloc] init];
    vc.pageModel = self.pageModel.model;
    [self.navigationController pushViewController:vc animated:YES];
//    CreateWordStudioController *vc = [[CreateWordStudioController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
//    AllStudiosController *vc = [[AllStudiosController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadServerData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,UrlPath_workplace];
    NSMutableDictionary *para = [@{
        @"sessionId": self.pageModel.sessionid,
    } mutableCopy];
   
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:para success:^(id data) {
        NSLog(@"获取工作站-->%@",data);
        [self hideHud];
        [self.pageModel configareWithData:data];
        if ([self.pageModel.model.retcode isEqualToString:@"0000"]) {
            NSInteger status = self.pageModel.model.status;
            switch (status) {
                case 1://未开通任何工作室
                {
                    self.naviRightButton.hidden = YES;
                    self.infoView.hidden = NO;
                    [self.infoView removeFromSuperview];
                    [self.view addSubview:self.infoView];
                    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view);
                    }];
                    [self.infoView configareWithTargetController:self data:self.pageModel.model];
        
                }
                    break;

                case 2://已加入工作室
                {
                    self.naviRightButton.hidden = NO;
                    self.groupListView.hidden = NO;
                   
                    [self.groupListView removeFromSuperview];
                    [self.view addSubview:self.groupListView];
                    [self.groupListView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view);
                    }];
                    [self.groupListView configareWithTargetController:self data:self.pageModel.model];
                }
                    break;

                case 3://创建的工作室在审核中
                case 4://加入申请在审核中
                {
                    self.naviRightButton.hidden = NO;
                    self.blankView.hidden = NO;
                    [self.blankView removeFromSuperview];
                    [self.view addSubview:self.blankView];
                    [self.blankView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view);
                    }];
                    if (status == 3) {
                        self.blankView.title = @"您创建的工作室正在审核，请耐心等待";
                    }else{
                        self.blankView.title = @"您申请的工作室正在审核，请耐心等待";
                    }
                    self.blankView.subTitle = @"您也可以点击右上角加入其他工作室";
                }
                    break;

                default:
                    break;
            }
        }else{
            [self addErrorViewWithMsg:self.pageModel.model.message];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"获取工作站error:%@",error);
        [self addErrorViewWithMsg:@"请求响应失败"];
    }];
    
}

- (void)addErrorViewWithMsg:(NSString *)msg
{
//    self.naviRightButton.hidden = NO;
    self.blankView.hidden = NO;
    [self.blankView removeFromSuperview];
    [self.view addSubview:self.blankView];
    [self.blankView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.blankView.title = @"点击重试";
    self.blankView.subTitle = msg;
    [self.blankView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadServerData)]];
}


- (UIButton *)naviRightButton
{
    if (!_naviRightButton) {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _naviRightButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_naviRightButton setTitleColor:greenC forState:UIControlStateNormal];
        [_naviRightButton setTitle:@"工作站介绍" forState:UIControlStateNormal];//@"查找群"
        _naviRightButton.backgroundColor = [UIColor whiteColor];
        CGFloat h = IPHONE_Y_SCALE(25);
        _naviRightButton.frame = CGRectMake(0, 0, IPHONE_X_SCALE(70), h);
        _naviRightButton.layer.cornerRadius = h/2.0f;
    }
    return _naviRightButton;
}

- (WorkSpaceInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[WorkSpaceInfoView alloc] init];
        _infoView.hidden = YES;
    }
    return _infoView;
}


- (WorkGroupListView *)groupListView
{
    if (!_groupListView) {
        _groupListView = [[WorkGroupListView alloc] init];
        _groupListView.hidden = YES;
    }
    return _groupListView;
}


- (WorkSpaceInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkSpaceInfoPageModel alloc] init];
        _pageModel.sessionid = sessionIding;
//        _pageModel.targetController = self;
    }
    return _pageModel;
}



- (WorkSpaceBlankView *)blankView
{
    if (!_blankView) {
        _blankView = [[WorkSpaceBlankView alloc] init];
        _blankView.hidden = YES;
    }
    return _blankView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
