//
//  WodeShoucangVideoViewController.m
//  GuKe
//
//  Created by MYMAc on 2018/3/23.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//

#import "WodeShoucangVideoViewController.h"
#import "WoDeShouCangTableViewCell.h"

#import "ZiXunDetailViewController.h"
#import "ZJNSignUpMeetingViewController.h"
#import "WYYShiPinDetailViewController.h"
#import "WYYShiPinTableViewCell.h"

#import "WYYShiPinModel.h"

@interface WodeShoucangVideoViewController()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *shoucangTable;
    NSMutableArray *collecArr;
    NSInteger page;
}


@end

@implementation WodeShoucangVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    page = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRefreshCollectList) name:@"collectList" object:nil];
    
    
    collecArr = [NSMutableArray array];
    [self makeaddTableview];
    [self makeData];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark 刷新收藏列表
- (void)didRefreshCollectList{
    [collecArr removeAllObjects];
    
    [self makeData];
}
#pragma mark 我的收藏
- (void)makeData{
//    page ++ ;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,videocollectionlistinfo];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的收藏视频%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
//            NSArray *collArr = [NSArray arrayWithArray:data[@"data"]];
//            if (page == 1) {
//                [collecArr removeAllObjects];
//            }
            
                for (NSDictionary * dic in data[@"data"]) {
                    WYYShiPinModel * models =[WYYShiPinModel yy_modelWithJSON:dic];
                    [collecArr addObject:models];
                }
    
            
        }else{
//            page --;
//            [self showHint:data[@"message"]];
        }
        [shoucangTable.mj_header endRefreshing];
        [shoucangTable.mj_footer endRefreshing];
        [self hideHud];
        [shoucangTable reloadData];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"我的收藏%@",error);
    }];
    
}
#pragma mark add view
- (void)makeaddTableview{
    shoucangTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, self.view.height - 45)];
    shoucangTable.delegate = self;
    shoucangTable.dataSource = self;
    shoucangTable.backgroundColor = SetColor(0xf0f0f0);
    shoucangTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:shoucangTable];
//    shoucangTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 0;
//        [self makeData];
//    }];
//
//    shoucangTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self makeData];
//    }];
    
    
    
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return collecArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 143;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid1";
    WYYShiPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WYYShiPinTableViewCell" owner:self options:nil]lastObject];
    }
    WYYShiPinModel * model =collecArr[indexPath.section];
    cell.model = model;
  
    NSLog(@"--- %ld",(long)indexPath.section);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

//    static NSString *cellIdter = @"cellId";
//    WoDeShouCangTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
//    if (!cellTwo) {
//        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WoDeShouCangTableViewCell" owner:self options:nil] lastObject];
//        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,collecArr[indexPath.section][@"image"]]] placeholderImage:[UIImage imageNamed:@"我组织的会议-img2"]];
//
//    cellTwo.img.clipsToBounds = YES;
//    cellTwo.contentMode = UIViewContentModeScaleAspectFill;
//
//    cellTwo.titlaLab.text = [NSString stringWithFormat:@"%@",collecArr[indexPath.section][@"title"]];
//
//    cellTwo.timeLab.text = [NSString stringWithFormat:@"%@",collecArr[indexPath.section][@"createTime"]];
//    return cellTwo;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYYShiPinModel * modle =collecArr[indexPath.section];
    WYYShiPinDetailViewController *detail = [[WYYShiPinDetailViewController alloc]init];
    detail.refershCollectStatusBlock = ^(NSString *CollectStatu) {
        modle.videoShou = CollectStatu;
        //   videoShou  1 已收藏  0 未收藏
        if([CollectStatu isEqualToString:@"0"]){
            [collecArr removeObjectAtIndex:indexPath.section];
        }else{
            [collecArr replaceObjectAtIndex:indexPath.section withObject:modle];
        }
        [tableView reloadData];
    };
    detail.videoId = [NSString stringWithFormat:@"%@",modle.videoId];
    detail.titleStr = [NSString stringWithFormat:@"%@",modle.videoName];
    detail.contentStr = [NSString stringWithFormat:@"%@",modle.videoContent];
    detail.videoShou = [NSString stringWithFormat:@"%@",modle.videoShou];
    detail.iconImagePath = [NSString stringWithFormat:@"%@",modle.videoImages];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
