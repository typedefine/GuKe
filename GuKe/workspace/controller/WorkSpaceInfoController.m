//
//  WorkGroupsInfoController.m
//  GuKe
//
//  Created by yb on 2020/11/1.
//  Copyright © 2020 shangyukeji. All rights reserved.
//

#import "WorkSpaceInfoController.h"
#import "WorkSpaceInfoPageModel.h"
#import "WorkSpaceInfoView.h"

@interface WorkSpaceInfoController ()

@property (nonatomic, strong) UIButton *naviRightButton;

@property (nonatomic, strong) WorkSpaceInfoPageModel *pageModel;
@property (nonatomic, strong) WorkSpaceInfoView *infoView;

@end

@implementation WorkSpaceInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];

    [self loadServerData];
}

- (void)setupUI
{
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3C3E3D]};
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x3C3E3D];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工作站";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.naviRightButton];
    [self.naviRightButton addTarget:self action:@selector(lookforGroup) forControlEvents:UIControlEventTouchUpInside];
    self.naviRightButton.hidden = YES;
    
//    [self.view addSubview:self.infoView];
//    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    self.infoView.hidden = YES;
}

- (void)lookforGroup
{
    
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
        NSDictionary *dict = (NSDictionary *)data;
        if ([dict[@"retcode"] isEqual:@"0000"]) {
            int status = [dict[@"status"] intValue];
            switch (status) {
                case 1://未开通任何工作室
                {
                    self.naviRightButton.hidden = YES;
                    self.infoView.hidden = NO;
                    [self.pageModel configareWithData:nil];
                    [self.infoView removeFromSuperview];
                    [self.view addSubview:self.infoView];
                    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self.view);
                    }];
                    [self.infoView configareWithData:self.pageModel.infoViewModel];
        
                }
                    break;

                case 2://已加入工作室
                {
                    self.naviRightButton.hidden = NO;
                }
                    break;

                case 3://创建的工作室在审核中
                {
                    self.naviRightButton.hidden = NO;
                }
                    break;

                case 4://加入申请在审核中
                {
                    self.naviRightButton.hidden = NO;
                }
                    break;

                default:
                    break;
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"病例--信息管理-修改信息error:%@",error);
    }];
    
}



- (WorkSpaceInfoPageModel *)pageModel
{
    if (!_pageModel) {
        _pageModel = [[WorkSpaceInfoPageModel alloc] init];
        _pageModel.sessionid = sessionIding;
        _pageModel.targetController = self;
    }
    return _pageModel;
}


- (UIButton *)naviRightButton
{
    if (!_naviRightButton) {
        _naviRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _naviRightButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_naviRightButton setTitleColor:greenC forState:UIControlStateNormal];
        [_naviRightButton setTitle:@"查找群" forState:UIControlStateNormal];
        _naviRightButton.backgroundColor = [UIColor whiteColor];
        CGFloat h = IPHONE_Y_SCALE(25);
        _naviRightButton.frame = CGRectMake(0, 0, IPHONE_X_SCALE(65), h);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
