//
//  MainViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "MainViewController.h"
#import "MainHuiYiViewController.h"//我的会议
#import "ZiXunDetailViewController.h"// 资讯
#import "ReMenHuiYiViewController.h"
#import "SuiFangTiXingViewController.h"
#import "WoDeHuanZheViewController.h"

#import "ShouShuListViewController.h"
//测试
#import "SuFangViewController.h"
#import "BaoMingRenYuanViewController.h"
#import "HuiYiJiLuViewController.h"
//wang start
#import "YshengChatViewController.h"//聊天列表
#import "WYYeMenShiPinViewController.h"//热门视频
#import "WYYShiPinDetailViewController.h"//热门视频详情
#import "WYYShiPinTableViewCell.h"
#import "WYYMainTableViewCell.h"//更多视频
#import "WYYHuanZheViewController.h"//修改后的我的患者

#import "ZJNSignUpMeetingViewController.h"//热门会议详情
#import "ZJNHotMeetingListModel.h"

#import "PersonViewController.h"
#import "WYYSearchShiPinViewController.h"
#import "LawVersionView.h"// 更新提示view
//end


@interface MainViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIScrollView *mainScroll;//顶部轮播图
    NSArray *_imagesURLStrings;
    UITableView *mainTableview;
    
    NSMutableArray *lunboArr;
    SDCycleScrollView *cycleScrollView2;
    BOOL isRenZheng;//是否认证
    NSString *nameDoc;
    NSString *shoushuStr;//手术数量
    NSString *huifangStr;//回访次数
    NSString *huanzheStr;//患者数量
    
    UIView *backView;
    
    UILabel *labeling;//医生名字
    NSMutableArray *videoArr;
    UIView *headerView;//头视图
    NSMutableArray *lunBArr;//轮播图数组
    
    //   下载连接
    NSString *  trackViewUrl ;

}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUpInfo];
    self.automaticallyAdjustsScrollViewInsets=NO;
        // Fallback on earlier versions
    self.title = @"首页";
    videoArr = [NSMutableArray array];
    lunboArr = [NSMutableArray array];
    shoushuStr = [NSString stringWithFormat:@"0"];
    huifangStr = [NSString stringWithFormat:@"0"];
    huanzheStr = [NSString stringWithFormat:@"0"];
    
    [self makerenzheng];
    [self makeVideoData];
    [self makeLunbotu];
    [self makeAddTableview];
    
    
    //这里注册一个通知 是为了在添加患者  添加手术  患者随访后 改变页面现实的数字
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makerenzheng) name:@"MainViewController" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 热门视频
- (void)makeVideoData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,pubvideolist];
    NSArray *keysArray = @[@"sessionId"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            NSArray *arrays = [NSArray arrayWithArray:data[@"data"]];
            for (NSDictionary *dica in arrays) {
                WYYShiPinModel *model = [WYYShiPinModel yy_modelWithJSON:dica];
                [videoArr addObject:model];
            }
            
        }
        [mainTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)viewDidLayoutSubviews
{
    if ([mainTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([mainTableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark add tableview
- (void)makeAddTableview{
    if (IS_IPGONE_X) {
        mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStyleGrouped];
    }else{
        mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)style:UITableViewStyleGrouped];
    }
    
    mainTableview.delegate = self;
    mainTableview.dataSource = self;
    mainTableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:mainTableview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return videoArr.count + 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 10;
    }else if (indexPath.row == 1){
        return 44;
    }else{
        return 143;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return lunboImgHeight + 225;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, lunboImgHeight + 225)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self makeAddView];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"celler";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.contentView.backgroundColor = SetColor(0xF0F0F0);
        return cell;
        
    }else if (indexPath.row == 1) {
        static NSString *cellider = @"cellid1er";
        WYYMainTableViewCell *celler = [tableView dequeueReusableCellWithIdentifier:cellider];
        if (!celler) {
            celler = [[[NSBundle mainBundle]loadNibNamed:@"WYYMainTableViewCell" owner:self options:nil]lastObject];
        }
        celler.selectionStyle = UITableViewCellSelectionStyleNone;
        celler.searchBlock = ^{
            WYYSearchShiPinViewController * searchVC = [[WYYSearchShiPinViewController alloc]init];
            searchVC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:searchVC animated:YES];
        };
        return celler;
    }else{
        static NSString *cellid = @"cellid1";
        WYYShiPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WYYShiPinTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = videoArr[indexPath.row - 2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
//        if (isRenZheng) {
            WYYeMenShiPinViewController *shi = [[WYYeMenShiPinViewController alloc]init];
            shi.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:shi animated:NO];
//        }else{
//            [self showHint:@"认证后可使用"];
//        }
    }else if(indexPath.row == 0){
        
    }else{
        WYYShiPinModel *modle = videoArr[indexPath.row - 2];
        WYYShiPinDetailViewController *detail = [[WYYShiPinDetailViewController alloc]init];
        detail.refershCollectStatusBlock = ^(NSString *CollectStatu) {
            modle.videoShou = CollectStatu;
            [videoArr replaceObjectAtIndex:indexPath.row - 2 withObject:modle];
            [tableView reloadData];
        };
        detail.videoId = [NSString stringWithFormat:@"%@",modle.videoId];
        detail.CanSaveDate = YES ;

        detail.titleStr = [NSString stringWithFormat:@"%@",modle.videoName];
        detail.contentStr = [NSString stringWithFormat:@"%@",modle.videoContent];
        detail.videoShou = [NSString stringWithFormat:@"%@",modle.videoShou];
        detail.iconImagePath = [NSString stringWithFormat:@"%@",modle.videoImages];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:NO];
    }
}
#pragma mark 首页 已有
- (void)makerenzheng{
    NSString *urlString = [NSString stringWithFormat:@"%@/app/doctor/list.json",requestUrl];
    NSArray *keysArray = @[@"sessionid"];
    NSArray *valueArray = @[sessionIding];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            huanzheStr = [NSString stringWithFormat:@"%@",data[@"data"][@"patient"]];
            shoushuStr = [NSString stringWithFormat:@"%@",data[@"data"][@"surgery"]];
            huifangStr = [NSString stringWithFormat:@"%@",data[@"data"][@"callback"]];
            nameDoc = [NSString stringWithFormat:@"%@",data[@"data"][@"doctorname"]];
            NSString *Zheng = [NSString stringWithFormat:@"%@",data[@"data"][@"status"]];
            if ([Zheng isEqualToString:@"1"]) {
                isRenZheng = YES;
            }else{
                isRenZheng = NO;
            }
            
            labeling.text = [NSString stringWithFormat:@"尊敬的%@医生",nameDoc];
            labeling.text = [labeling.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            
                UILabel *labelOne = (UILabel *)[self.view viewWithTag:100];
                labelOne.text =[NSString stringWithFormat:@"%@台手术",shoushuStr];
               // [Utile setUILabel:labelOne data:nil setData:shoushuStr color:greenC font:19 underLine:NO];
            
                UILabel *labelTwo = (UILabel *)[self.view viewWithTag:101];
                labelTwo.text =[NSString stringWithFormat:@"%@份病例",huanzheStr];
               // [Utile setUILabel:labelTwo data:nil setData:huanzheStr color:greenC font:19 underLine:NO];
            
                UILabel *labelThree = (UILabel *)[self.view viewWithTag:102];
                labelThree.text =[NSString stringWithFormat:@"%@人次",huifangStr];
               // [Utile setUILabel:labelThree data:nil setData:huifangStr color:greenC font:19 underLine:NO];

        }else if ([retcode isEqualToString:@"1"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:key_login_notification object:@NO];
            [self showHint:data[@"message"]];
        }
        [mainTableview reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"连接服务器失败"];
        NSLog(@"%@",error);
    }];
}
#pragma mark 轮播图展示
- (void)makeLunbotu{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,carouselcarouselimg];
    NSArray *keysArray = @[@"sessionid",@"biztype"];
    NSArray *valueArray = @[sessionIding,@"1"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
//    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"轮播图展示%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
           
            lunBArr = [NSMutableArray arrayWithArray:data[@"data"]];
            for (NSDictionary *dica in lunBArr) {
                NSString *urlStrs = [NSString stringWithFormat:@"%@%@",imgPath,[dica objectForKey:@"path"]];
                [lunboArr addObject:urlStrs];
                
                //         --- 模拟加载延迟
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    cycleScrollView2.imageURLStringsGroup = lunboArr;
                });
            }
            
            [mainTableview reloadData];
            
        }else{
            
        }
        
//        [self hideHud];
    } failure:^(NSError *error) {
//        [self hideHud];
        NSLog(@"轮播图展示%@",error);
    }];
}
- (void)makeAddView{
    //此处添加一个view是为了使TableView不再是self.view的第一子视图，从而解决了隐藏导航栏后，tableview向下偏移20个像素的bug
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:view];
    //轮播图
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, lunboImgHeight)];
    [headerView addSubview:mainScroll];
    
    // 网络加载 --- 创建带标题的图片轮播器
    cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,ScreenWidth ,lunboImgHeight) delegate:self placeholderImage:[UIImage imageNamed:@"default_img"]];
    cycleScrollView2.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    cycleScrollView2.clickItemOperationBlock = ^(NSInteger currentIndex) {
//        NSLog(@"selectData = %@",lunBArr[currentIndex]);
//    };
    [mainScroll addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = lunboArr;
    });
    
    
    
    mainScroll.frame  = CGRectMake(0, 0, ScreenWidth, lunboImgHeight);
//    @"我的患者",
    NSArray *titleArray = [NSArray arrayWithObjects:@"专项培训",@"热门会议",@"医生好友", nil];
//    @"我的患者-icon",
    NSArray *imgArr = [NSArray arrayWithObjects:@"专项培训",@"我的会议-icon",@"我的随访-icon", nil];
    //轮播图下面的按钮
    CGFloat allImaegWidth = 65 * imgArr.count;
    for (int a= 0; a < imgArr.count; a ++) {
//        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 260)/5 + ((ScreenWidth - 260)/5 + 65)* a, CGRectGetMaxY(mainScroll.frame)+10, 65, 65)];
    
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - allImaegWidth)/4 + ((ScreenWidth - allImaegWidth)/4 + 65)* a, CGRectGetMaxY(mainScroll.frame)+10, 65, 65)];

        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[a]]];
        [headerView addSubview:img];
        
//        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(25 + ((ScreenWidth - 265)/2 + 65)*a, CGRectGetMaxY(img.frame)+ 10, 85, 20)];
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(25 + ((ScreenWidth - allImaegWidth)/2 + 65)*a, CGRectGetMaxY(img.frame)+ 10, 85, 20)];
        labels.textColor = SetColor(0x1a1a1a);
        labels.centerX = img.centerX;
        labels.textAlignment = NSTextAlignmentCenter;
        labels.text = [NSString stringWithFormat:@"%@",titleArray[a]];
        labels.font = Font14;
        [headerView addSubview:labels];
        
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0 + ScreenWidth/imgArr.count * a, CGRectGetMaxY(mainScroll.frame), ScreenWidth/imgArr.count,135 )];
        btns.tag = a + 10 +1;
        [btns addTarget:self action:@selector(didButtons:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btns];
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScroll.frame) + 115, ScreenWidth, 10)];
    lineView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineView];
    
    
    //
    UIImageView *imgimgs = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, 20, 20)];
    imgimgs.image = [UIImage imageNamed:@"消息main"];
    [headerView addSubview:imgimgs];
    
    labeling = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgimgs.frame)+ 5, CGRectGetMaxY(lineView.frame) + 10, 280, 20)];
    labeling.font = Font15;
    labeling.textColor = SetColor(0x333333);
    labeling.text = [NSString stringWithFormat:@"尊敬的%@医生",nameDoc];
    labeling.text = [labeling.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    [headerView addSubview:labeling];
    for (int a = 0; a < 3; a ++) {
        
        UILabel *labesls = [[UILabel alloc]initWithFrame:CGRectMake(0+  ScreenWidth/3*a, CGRectGetMaxY(labeling.frame)+ 10, ScreenWidth/3, 20)];
        labesls.textColor = detailTextColor;
        labesls.numberOfLines = 1;
        labesls.textAlignment = NSTextAlignmentCenter;
        labesls.font =Font14;
        [headerView addSubview:labesls];
        
        UILabel *labeslTwo = [[UILabel alloc]initWithFrame:CGRectMake(0+  ScreenWidth/3*a, CGRectGetMaxY(labesls.frame), ScreenWidth/3, 20)];
        labeslTwo.tag = 100 + a;
        labeslTwo.textColor = detailTextColor;
        labeslTwo.numberOfLines = 1;
        labeslTwo.textAlignment = NSTextAlignmentCenter;
        labeslTwo.font = Font14;
        [headerView addSubview:labeslTwo];
        
        if (a == 0) {
            labesls.text = [NSString stringWithFormat:@"您已经做"];
            labeslTwo.text =[NSString stringWithFormat:@"%@台手术",shoushuStr];
            [Utile setUILabel:labeslTwo data:nil setData:shoushuStr color:greenC font:19 underLine:NO];
            
        }else if (a == 1){
            labesls.text = [NSString stringWithFormat:@"拥有"];
            labeslTwo.text =[NSString stringWithFormat:@"%@份病例",huanzheStr];
            [Utile setUILabel:labeslTwo data:nil setData:huanzheStr color:greenC font:19 underLine:NO];
        }else{
            labesls.text = [NSString stringWithFormat:@"随访"];
            labeslTwo.text =[NSString stringWithFormat:@"%@人次",huifangStr];
            [Utile setUILabel:labeslTwo data:nil setData:huifangStr color:greenC font:19 underLine:NO];
        }
        
        
        
        UIButton *threeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0+  ScreenWidth/3*a, CGRectGetMaxY(labeling.frame)+ 20, ScreenWidth/3, 40)];
        [threeBtn addTarget:self action:@selector(didThreeButton:) forControlEvents:UIControlEventTouchUpInside];
        threeBtn.tag = 100 + a;
        [headerView addSubview:threeBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3* a, CGRectGetMaxY(labeling.frame)+ 25, 1, 30)];
        lineView.backgroundColor = SetColor(0xe0e0e0);
        [headerView addSubview:lineView];
        
    }
    
    
    
//    UIButton *btnsing = [[UIButton alloc]initWithFrame:CGRectMake(70,CGRectGetMaxY(labeling.frame)+ 60,ScreenWidth - 140 ,ScreenHeight - (CGRectGetMaxY(labeling.frame)+ 60) - 49)];
//    [btnsing setImage:[UIImage imageNamed:@"消息sui"] forState:normal];
//    [btnsing addTarget:self action:@selector(didSuiButton) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:btnsing];
}

//- (void)didSuiButton{
//    if (isRenZheng) {
//        WYYeMenShiPinViewController *shi = [[WYYeMenShiPinViewController alloc]init];
//        shi.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:shi animated:NO];

//        SuiFangTiXingViewController *ti = [[SuiFangTiXingViewController alloc]init];
//        ti.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ti animated:NO];
//    }else{
//        [self showHint:@"认证后可使用"];
//    }
    
//}
#pragma mark 尊敬的何潇医生
- (void)didThreeButton:(UIButton *)sender{
//    if (isRenZheng) {
        if (sender.tag == 100) {
            ShouShuListViewController *list = [[ShouShuListViewController alloc]init];
            list.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:list animated:NO];
            
        }else if (sender.tag == 101){
            WoDeHuanZheViewController *bao = [[WoDeHuanZheViewController alloc]init];
            bao.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bao animated:NO];
            
        }else{
            
            SuiFangTiXingViewController *sui = [[SuiFangTiXingViewController alloc]init];
            sui.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sui animated:NO];
        }

//    }else{
//        [self showHint:@"认证后可使用"];
//    }
    
}
#pragma mark  隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    [self makerenzheng];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 我的患者  我的会议  我的随访  按钮点击事件
- (void)didButtons:(UIButton *)sender{
//    if (!isRenZheng) {
//        [self showHint:@"认证后可使用"];
//        return;
//    }
    //我的患者 修改
    if (sender.tag == 10) {
     
        WYYHuanZheViewController *huan = [[WYYHuanZheViewController alloc]init];
        huan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:huan animated:NO];
        
//        WoDeHuanZheViewController *bao = [[WoDeHuanZheViewController alloc]init];
//        bao.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:bao animated:NO];
//专项培训
    }else if (sender.tag == 11 || sender.tag ==12){
     
        if(isRenZheng){
            
        if(sender.tag == 11){
         ReMenHuiYiViewController *huiyi = [[ReMenHuiYiViewController alloc]init];
        huiyi.hidesBottomBarWhenPushed = YES;
        huiyi.mettingMoodel = @"1";
        huiyi.title = @"专项培训";

                [self.navigationController pushViewController:huiyi animated:NO];
        }else if (sender.tag  == 12){
                ReMenHuiYiViewController *huiyi = [[ReMenHuiYiViewController alloc]init];
                huiyi.hidesBottomBarWhenPushed = YES;
                huiyi.mettingMoodel = @"0";
                huiyi.title = @"热门学术会议";
                
                [self.navigationController pushViewController:huiyi animated:NO];
        }
        }else{
            UIAlertController * AlerView =[UIAlertController alertControllerWithTitle:@"提示" message:@"认证后可访问！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * sure =[UIAlertAction actionWithTitle:@"立即认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self goRenZheng];

            }];
            [AlerView addAction:cancel];
            [AlerView addAction:sure];
            [self presentViewController:AlerView animated:YES completion:NO] ;

        }
        //        MainHuiYiViewController *huiyi = [[MainHuiYiViewController alloc]init];
        //        huiyi.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:huiyi animated:NO];
        //热门学术会议
        
        //        MainHuiYiViewController *huiyi = [[MainHuiYiViewController alloc]init];
        //        huiyi.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:huiyi animated:NO];
        //我的随访
    }else{
        
        YshengChatViewController *bao = [[YshengChatViewController alloc]init];
        //bao.typeStr = [NSString stringWithFormat:@"1"];
        bao.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bao animated:NO];
//        SuFangViewController *bao = [[SuFangViewController alloc]init];
//        bao.typeStr = [NSString stringWithFormat:@"1"];
//        bao.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:bao animated:NO];


    }
}
-(void)goRenZheng{
    
    PersonViewController *detail = [[PersonViewController alloc]init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.pushcoming = YES;
    [self.navigationController pushViewController:detail animated:NO];
    
}
#pragma mark - SDCycleScrollViewDelegate 轮播图代理

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
//    if (isRenZheng) {
//  biztype      链接类型0无1会议2资讯3视频4个人资料
        int   biza =[ lunBArr[index][@"biztype"] intValue ];
          if ( biza == 1) {//1会议
            ZJNSignUpMeetingViewController *yi = [[ZJNSignUpMeetingViewController alloc]init];
            yi.status = [NSString stringWithFormat:@"%@",lunBArr[index][@"collect"]];
            yi.huiyiID = [NSString stringWithFormat:@"%@",lunBArr[index][@"bizid"]];
            yi.live = [NSString stringWithFormat:@"%@",lunBArr[index][@"live"]];
            yi.shareImagePath = [NSString stringWithFormat:@"%@",lunBArr[index][@"path"]];
            yi.urlStr  = [NSString stringWithFormat:@"%@app/meeting/type_show.json?uid=%@",requestUrl, [NSString stringWithFormat:@"%@",lunBArr[index][@"bizid"]]];
              
              yi.specialAllow = [NSString stringWithFormat:@"%@",lunBArr[index][@"specialAllow"]];;
              yi.meetingModel = [NSString stringWithFormat:@"%@",lunBArr[index][@"meetingModel"]];
              yi.payState = [NSString stringWithFormat:@"%@",lunBArr[index][@"payState"]];
              yi.meetShow = [NSString stringWithFormat:@"%@",lunBArr[index][@"meetShow"]];
              yi.switchState = [NSString stringWithFormat:@"%@",lunBArr[index][@"switchState"]];
            yi.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yi animated:NO];
              NSMutableDictionary * dataDic =[[NSMutableDictionary alloc]initWithDictionary:lunBArr[index]];
              yi.refershList = ^(NSString *type) {
                  [dataDic setValue:type forKey:@"collect"];
                  [lunBArr replaceObjectAtIndex:index withObject:dataDic];
              };
              
              
              
        }else if (biza == 2){//2资讯
           
            ZiXunDetailViewController *detail = [[ZiXunDetailViewController alloc]init];
            detail.title = @"资讯详情";
            detail.zixunID = [NSString stringWithFormat:@"%@",lunBArr[index][@"bizid"]];
            detail.hidesBottomBarWhenPushed = YES;
            detail.titleStr = [NSString stringWithFormat:@"%@",lunBArr[index][@"bizidName"]];;
            detail.iconImagePath = [NSString stringWithFormat:@"%@",lunBArr[index][@"path"]];;
            detail.contentStr = [NSString stringWithFormat:@"%@",lunBArr[index][@"desc"]];;
            detail.typeStr = [NSString stringWithFormat:@"%@",lunBArr[index][@"collect"]];
            
            NSMutableDictionary * dataDic =[[NSMutableDictionary alloc]initWithDictionary:lunBArr[index]];
            detail.refershCollectStatusBlock = ^(NSString *shou) {
                
                [dataDic setValue:shou forKey:@"collect"];
                [lunBArr replaceObjectAtIndex:index withObject:dataDic];
            };
            [self.navigationController pushViewController:detail animated:NO];


            
            
        }else if (biza == 3){//3视频
            
            
            WYYShiPinDetailViewController *detail = [[WYYShiPinDetailViewController alloc]init];
            NSMutableDictionary * dataDic =[[NSMutableDictionary alloc]initWithDictionary:lunBArr[index]];

            detail.refershCollectStatusBlock = ^(NSString *CollectStatu) {
                [dataDic setValue:CollectStatu forKey:@"collect"];
                [lunBArr replaceObjectAtIndex:index withObject:dataDic];
            };
            detail.videoId = [NSString stringWithFormat:@"%@",lunBArr[index][@"bizid"]];
            detail.CanSaveDate = YES  ;

            detail.titleStr = [NSString stringWithFormat:@"%@",lunBArr[index][@"bizidName"]];
            detail.contentStr = [NSString stringWithFormat:@"%@",lunBArr[index][@"desc"]];
            detail.videoShou = [NSString stringWithFormat:@"%@",lunBArr[index][@"collect"]];
            detail.iconImagePath = [NSString stringWithFormat:@"%@",lunBArr[index][@"path"]];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:NO];
            
        }else if (biza == 4){//4个人资料
 
            PersonViewController *detail = [[PersonViewController alloc]init];
            detail.hidesBottomBarWhenPushed = YES;
            detail.pushcoming = YES;
            [self.navigationController pushViewController:detail animated:NO];

        }
        //ZJNHotMeetingListModel *model = lunBArr[index];
       
//        ReMenHuiYiViewController *ren = [[ReMenHuiYiViewController alloc]init];
//        ren.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ren animated:NO];
        

//    }else{
//
//        [self showHint:@"认证后可使用"];
//    }
    
}

#pragma mark -- SlideSwitchSubviewDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:viewController animated:animated];
}


-(void)getUpInfo{
    [self judgeVersion];
    return ;
//    NSString * url ;
//    NSDictionary * dic  =[[NSMutableDictionary alloc]init];
////    NewPublicCheck
//    NSMutableDictionary * valudic =[[NSMutableDictionary alloc]init];
//    [valudic setValue:@"1" forKey:@"type"];
//    [ZJNRequestManager postWithUrlString:url parameters:valudic success:^(id data) {
//        NSString  * str =[NSString stringWithFormat:@"%@",data[@"status"]];
//        if ([str isEqualToString:@"0"]) {
//            NSString * isUp = [NSString stringWithFormat:@"%@",data[@"data"][@"is_update"]];
//            if([isUp isEqualToString:@"1"]){
//                //    is_update   1  更新  0  不更新
//                [self judgeVersion];
//            }
//        }
//    } failure:^(NSError *error) {
//
//        NSLog(@"%@",error);
//    }];
    
    
}

#pragma mark 判断版本
-(void)judgeVersion{
    //    is_update   1  更新  0  不更新
    NSString *url = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/lookup?id=%@",@"1306407596"];
    [ZJNRequestManager postWithUrlString:url parameters:nil success:^(id data) {
        
    NSArray *array = data[@"results"];
        
        NSDictionary *dict = [array lastObject];
        NSString * APPStoreVersion = [NSString stringWithFormat:@"%@",dict[@"version"]];
        NSString *APPVersion  =[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        trackViewUrl = [NSString stringWithFormat:@"%@",dict[@"trackViewUrl"]];
        APPVersion = [APPVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        APPStoreVersion = [APPStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
//
        
        if ([APPVersion integerValue] < [APPStoreVersion integerValue]) {
            UIAlertController * AlerView =[UIAlertController alertControllerWithTitle:@"版本提示" message:dict[@"releaseNotes"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];

            }];
            [AlerView addAction:cancel];
            [AlerView addAction:sure];
            [self presentViewController:AlerView animated:YES completion:NO] ;
//            LawVersionView * VersionView =[[[NSBundle mainBundle]loadNibNamed:@"LawVersionView" owner:self options:nil]lastObject];
//            VersionView.frame = self.view.bounds;
//            VersionView.height = ScreenHeight;
//            VersionView.ConcentLB.text =dict[@"releaseNotes"];
//            [VersionView makeUI ];
//
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: VersionView.ConcentLB.text];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            [paragraphStyle setLineSpacing:10];
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [VersionView.ConcentLB.text length])];
//            VersionView.ConcentLB.attributedText = attributedString;
//            [VersionView.ConcentLB sizeToFit];
//            VersionView.VersionLB.text =[NSString stringWithFormat:@"V%@",APPStoreVersion];
//            [[UIApplication sharedApplication].delegate.window addSubview:VersionView];
//            VersionView.UpAction = ^{
//
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
//            };
        }else{
            
        }
        
        
        
     } failure:^(NSError *error) {
        
    }];
    
    //1340683771 用户端
    //1340083961 律师端
    
    
    
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
