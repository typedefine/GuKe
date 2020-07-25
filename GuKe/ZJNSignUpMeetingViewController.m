//
//  ZJNSignUpMeetingViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/21.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNSignUpMeetingViewController.h"
#import "ZJNMeetingInfoModel.h"
#import "ZJNSingUpMeetingPeopleTableViewCell.h"
#import "BaoMingRenYuanViewController.h"
#import "ZJNLiveRoomViewController.h"
#import "ZJNSignUpMeetingInfoTableViewCell.h"//展示会议基本信息
#import "ZJNSignUpMeetingIntroduceTableViewCell.h"//展示会议介绍
#import "H5ViewController.h"
#import "QjcBackSelectView.h"
#import <WebKit/WebKit.h>
#import "OrderDetailViewController.h"


#import "WYYShiPinDetailViewController.h"
 
@interface ZJNSignUpMeetingViewController ()<UITableViewDelegate ,UITableViewDataSource,backSelectDelegate,WKUIDelegate,WKNavigationDelegate>
{
    
    
    
    CGFloat cellHeight;//会议详情单元格高度可变
    ZJNMeetingInfoModel *infoModel;
    UIView *heiseView;
    UIImageView *whiteView;
    QjcBackSelectView * SelectView;
    NSString * ShareMeetShow;// 分享时候的meetShow；
}
@property (nonatomic ,strong)UITableView *tableView;// 瀑布用tableview显示
@property (nonatomic ,strong)WKWebView *webviews;// 九宫格用 web显示

@end

@implementation ZJNSignUpMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"会议详情";
    UIBarButtonItem *TwoBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MORE"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedTwoView)];
    self.navigationItem.rightBarButtonItem = TwoBarItem;
    cellHeight = 225;
    ShareMeetShow  = self.meetShow;
    [self makeAddView];
    [self makeSelectView];
    [self getDataFromService];
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-44-TabbarAddHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(WKWebView *)webviews{
    if (!_webviews) {
        _webviews = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight-44-TabbarAddHeight)];
        _webviews.UIDelegate = self;
        _webviews.navigationDelegate = self;
        [self.view addSubview:_webviews];
        NSURL *url = [NSURL URLWithString:self.urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webviews loadRequest:request];
    }
 
    
    //    NSString *urlString = [NSString stringWithFormat:@"%@/app/information/show.json?uid=%@",requestUrl,self.orderNumber];
   
    return _webviews;
}
-(void)creatBottomButton{
    NSString *live = [NSString stringWithFormat:@"%@",self.live];//0 无  1 直播中  2回放
    UIButton *btns = [UIButton buttonWithType:UIButtonTypeCustom];// 关注Btn
    UIButton * stylebtn  = [UIButton buttonWithType:UIButtonTypeCustom];// 模式btn
    UIButton * signUP  = [UIButton buttonWithType:UIButtonTypeCustom];// 报名btn
    UIButton *liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    
    if ([live isEqualToString:@"0"]) {
        if([self.specialAllow isEqualToString:@"1"]){
            //            有报名无观看
        stylebtn.frame = CGRectMake(0, ScreenHeight-44-NavBarHeight-TabbarAddHeight, ScreenWidth/9*2, 44);
        btns.frame = CGRectMake(stylebtn.right, stylebtn.top,ScreenWidth/3, stylebtn.height);
        signUP.frame = CGRectMake(btns.right, stylebtn.top, ScreenWidth/9*4, stylebtn.height);
            
        }else{
//            无报名无观看
           
            stylebtn.frame = CGRectMake(0, ScreenHeight-44-NavBarHeight-TabbarAddHeight, ScreenWidth/5*2, 44);
            btns.frame = CGRectMake(stylebtn.right, stylebtn.top,ScreenWidth/5*3, stylebtn.height);
//            signUP.frame = CGRectMake(btns.right, stylebtn.top, ScreenWidth/9*4, stylebtn.height);
            
        }
    }else{
        CGFloat  halfWidth = ScreenWidth/2.5;//观看回放的宽度
        if([self.payState isEqualToString:@"0"]&&[live isEqualToString:@"2"]){
             halfWidth = 0;  //观看回放的宽度
        } 
        CGFloat  leftWidth = ScreenWidth - halfWidth;
        // meetingModel  0 热门会议 1 专项会议
        if([self.meetingModel isEqualToString:@"1"] &&[self.payState isEqualToString:@"0"]){// 专项会议且 paystate = 0不能看回放   无观看权限  观看按钮
            
           
            if([self.specialAllow isEqualToString:@"1"]){//有报名
                stylebtn.frame = CGRectMake(0, ScreenHeight-44-NavBarHeight-TabbarAddHeight, ScreenWidth/9*3, 44);
                btns.frame = CGRectMake(stylebtn.right, stylebtn.top,ScreenWidth/9*3, stylebtn.height);
                signUP.frame = CGRectMake(btns.right, stylebtn.top, leftWidth/9*3, stylebtn.height);

            } else{// 没报名
                stylebtn.frame = CGRectMake(0, ScreenHeight-44-NavBarHeight-TabbarAddHeight, ScreenWidth/2, 44);
                btns.frame = CGRectMake(stylebtn.right, stylebtn.top,ScreenWidth/2, stylebtn.height);
                signUP.frame = CGRectMake(btns.right, stylebtn.top, 0, stylebtn.height);
            }

        }else{
        
        if([self.specialAllow isEqualToString:@"1"]){
//            有报名有观看
            stylebtn.frame = CGRectMake(0, ScreenHeight-44-NavBarHeight-TabbarAddHeight, leftWidth/9*3, 44);
            btns.frame = CGRectMake(stylebtn.right, stylebtn.top,leftWidth/3, stylebtn.height);
            signUP.frame = CGRectMake(btns.right, stylebtn.top, leftWidth/9*3, stylebtn.height);
            liveBtn.frame  =  CGRectMake(signUP.right, ScreenHeight-44-NavBarHeight-TabbarAddHeight, halfWidth, 44);
        }else{
            //            无报名有观看
            stylebtn.frame = CGRectMake(0, ScreenHeight-44-NavBarHeight-TabbarAddHeight, leftWidth/2, 44);
            btns.frame = CGRectMake(stylebtn.right, stylebtn.top,leftWidth/2, stylebtn.height);
             liveBtn.frame  =  CGRectMake(btns.right, ScreenHeight-44-NavBarHeight-TabbarAddHeight, halfWidth, 44);
        }
        
        }
       
    }
//    关注Btn
    btns.backgroundColor = [UIColor whiteColor];
    btns.tag = 10;
    [btns setTitle:@"关注" forState:normal];
    [btns setTitle:@"取消关注" forState:UIControlStateSelected];
    [btns setImage:[UIImage imageNamed:@"new_heat"] forState:UIControlStateNormal];
    [btns setImage:[UIImage imageNamed:@"new_heat_select"] forState:UIControlStateSelected];
    [btns setTitleColor:detailTextColor forState:normal];
    btns.titleLabel.font = [UIFont systemFontOfSize:13];
    [btns addTarget:self action:@selector(didCollectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btns];
//   模式Btn
    stylebtn.backgroundColor = [UIColor whiteColor];
    [stylebtn setImage:[UIImage imageNamed:@"new导航-"] forState:UIControlStateNormal];
    [stylebtn setTitle:@"切换模式" forState:UIControlStateNormal];
    [stylebtn setTitleColor:detailTextColor forState:UIControlStateNormal];
    if([self.switchState isEqualToString:@"0"]){
        stylebtn.userInteractionEnabled = NO ;
    }
    
    stylebtn.titleLabel.font =[UIFont systemFontOfSize:13];
    [stylebtn setTitleEdgeInsets:UIEdgeInsetsMake(stylebtn.imageView.frame.size.height + 8 ,-stylebtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [stylebtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 0.0,0.0, -stylebtn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边

    
    [stylebtn addTarget:self action:@selector(styleseleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stylebtn];
//    报名
    
     signUP.backgroundColor =greenC;
     [signUP setTitle:@"报名" forState:normal];
    
    [signUP setTitleColor:[UIColor whiteColor] forState:normal];
    signUP.titleLabel.font = Font15;
    
  
    [signUP addTarget:self action:@selector(didBaoMingBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUP];
    if ([_status isEqualToString:@"1"]) {
        btns.selected = YES;
    }
    [btns setTitleEdgeInsets:UIEdgeInsetsMake(btns.imageView.frame.size.height +8,-btns.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btns setImageEdgeInsets:UIEdgeInsetsMake(-15, 0.0,0.0, -btns.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
  
    
    if (![live isEqualToString:@"0"]) {
        liveBtn.backgroundColor =greenC ;
        [liveBtn setTitleColor:[UIColor whiteColor] forState:normal];
        liveBtn.titleLabel.font = Font15;
        [liveBtn addTarget:self action:@selector(liveView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:liveBtn];
        
        if ([live isEqualToString:@"1"]) {
            [liveBtn setTitle:@"观看直播" forState:normal];
        }else if ([live isEqualToString:@"2"]){
            [liveBtn setTitle:@"观看回放" forState:normal];
        }
    }
    
}
#pragma mark 分享按钮
- (void)onClickedTwoView{
    heiseView.hidden = NO;
}
- (void)makeAddView{
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [[[UIApplication sharedApplication]keyWindow] addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    whiteView  = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 54, 140, 44*3)];
    whiteView.userInteractionEnabled = YES;
    whiteView.image = [UIImage imageNamed:@"分享背景"];
    [heiseView addSubview:whiteView];
    
    NSArray *imgArr= [NSArray arrayWithObjects:@"分享-微信-好友2",@"分享-微-朋友圈-",@"分享-站内好友", nil];
    NSArray *nameArray = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"QQ", nil];
    for (int a = 0; a < imgArr.count; a ++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12 + 44*a, 20, 20)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[a]]];
        [whiteView addSubview:img];
        
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+ 5, 12 + 44*a, 100, 20)];
        labels.font = [UIFont systemFontOfSize:14];
        labels.textColor = titColor;
        labels.text = [NSString stringWithFormat:@"%@",nameArray[a]];
        [whiteView addSubview:labels];
        
        UIView *lineVew = [[UIView alloc]initWithFrame:CGRectMake(10,44 + 44*a, 127, 1)];
        lineVew.backgroundColor = SetColor(0xe0e0e0);
        [whiteView addSubview:lineVew];
        if (a == imgArr.count-1) {
            lineVew.hidden = YES;
        }
        
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0, 10 + 0 + 44*a, 140, 44)];
        btns.tag = 10 + a;
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btns];
    }
}
- (void)didViewBlockView{
    heiseView.hidden =YES;
    
}
- (void)didButton:(UIButton *)sender{
    heiseView.hidden = YES;
    if (sender.tag == 10) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if (sender.tag == 11){
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    else if (sender.tag == 12){
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }else{
        [self makeCollection];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden = NO;  //状态栏隐藏  NO显示

}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = [NSString stringWithFormat:@"%@%@",imgPath,self.shareImagePath];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:infoModel.meetingName descr:infoModel.content thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@?uid=%@&meetShow=%@",requestUrl,fxMeeting,self.huiyiID,ShareMeetShow];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
}
-(void)getDataFromService{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,meetingshow];
    NSArray *keysArray = @[@"sessionid",@"uid"];
    NSArray *valueArray = @[sessionIding,self.huiyiID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"会议报名/会议详情%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSDictionary *dic = data[@"data"];
            infoModel = [ZJNMeetingInfoModel yy_modelWithDictionary:dic];
        }else{
            [self showHint:data[@"message"]];
        }
        if ([self.meetShow isEqualToString:@"1"]) {
            [self.view addSubview:self.webviews];
        }else{
        [self.view addSubview:self.tableView];
        }
        [self creatBottomButton];
        if (infoModel.liveList.count > 0) {
            SelectView =  [[QjcBackSelectView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight-44-TabbarAddHeight)];
            SelectView.backgroundColor =[UIColor colorWithHex:0x000000 alpha:.3];
            SelectView.delegate = self;
            SelectView.hidden = YES;
            SelectView.DataArray = infoModel.liveList;
            [self.view addSubview:SelectView];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"会议报名/会议详情%@",error);
    }];
}

-(void)selectItemWithIndex:(NSInteger)index{
    SelectView.hidden = YES;
    NSDictionary * dic = infoModel.liveList[index];
    NSLog(@"index = %ld  dic = %@",index,dic);

    ZJNLiveRoomViewController *view = [[ZJNLiveRoomViewController alloc]init];
    view.huiyiID =[NSString stringWithFormat:@"%@",[dic objectForKey:@"roomId"]];//self.huiyiID;
    view.title = @"直播间";
    view.titleStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"roomName"]];// infoModel.meetingName;
    view.concent =infoModel.content;
    view.shareImagePath = self.shareImagePath;
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:NO];

}
#pragma mark--观看直播
-(void)liveView{
    if (infoModel.liveList.count > 0) {
        SelectView.hidden = NO;

    }else{
        ZJNLiveRoomViewController *view = [[ZJNLiveRoomViewController alloc]init];
        view.huiyiID = self.huiyiID;
        view.title = @"回放视频";
        view.isBack = @"1";
        view.titleStr =self.sharetitle;
        view.concent =infoModel.content;
        view.shareImagePath = self.shareImagePath;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:NO];
    }
    

    
}
#pragma mark--UITableViewDelegate ,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSDictionary *attr1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
            
            NSDictionary *attr2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
            
            CGFloat titleHeight = [infoModel.meetingName boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attr1 context:nil].size.height;
            
            CGFloat addressHeight = [infoModel.site boundingRectWithSize:CGSizeMake(ScreenWidth-27-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attr2 context:nil].size.height;
//            return MAX(92, 100+titleHeight+MAX(15, addressHeight));
            return 100+titleHeight+MAX(15, addressHeight) -15;
            
        }else{
            return [ZJNSignUpMeetingIntroduceTableViewCell cellHeight];
        }
        
    }
    return 150;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellid = @"cellid";
            ZJNSignUpMeetingInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZJNSignUpMeetingInfoTableViewCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = infoModel;
            return cell;
        }else{
            static NSString *cellid = @"cellID";
            ZJNSignUpMeetingIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[ZJNSignUpMeetingIntroduceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.htmlString = infoModel.newcontent;
            __weak ZJNSignUpMeetingViewController *weakSelf = self;
            cell.reloadBlock =^()
            {
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                [weakSelf.tableView reloadData];
            };
            return cell;
        }
        
    }else{
        static NSString *cellid = @"celliden";
        ZJNSingUpMeetingPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[ZJNSingUpMeetingPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = infoModel;
        [cell.moreButton setHidden:YES];
        [cell.moreButton addTarget:self action:@selector(didGenduoButton) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark--更多报名
-(void)didGenduoButton{
    BaoMingRenYuanViewController *ren = [[BaoMingRenYuanViewController alloc]init];
    ren.docArr = infoModel.doctor;
    ren.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ren animated:NO];
}

#pragma mark 添加我的收藏
- (void)makeCollection{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,collectionadd];
    NSArray *keysArray = @[@"sessionid",@"meetingid"];
    NSArray *valueArray = @[sessionIding,self.huiyiID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        
        NSLog(@"添加我的收藏%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"添加我的收藏%@",error);
    }];
}

#pragma mark  报名按钮
-(void)didBaoMingBtn{
    NSLog(@"报名");
//    H5ViewController * hvc =[[H5ViewController alloc]init];
//    hvc.urlStr = [NSString stringWithFormat:@"%@/app/meeting/order.json?sessionId=%@&uid=%@",requestUrl,sessionIding,self.huiyiID];
//    hvc.title = @"报名";
//    [self.navigationController pushViewController:hvc animated:YES];
    
    
    OrderDetailViewController * detail =[[OrderDetailViewController alloc]init];
    detail.title = @"报名";
    MJWeakSelf
    detail.reloadBlock = ^{
//        [weakSelf loadData];
    };
    NSString * urlStr ;
     urlStr = [NSString stringWithFormat:@"%@/app/meeting/order.json?sessionId=%@&uid=%@",requestUrl,sessionIding,self.huiyiID];

     detail.urlStr = urlStr;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
    
    
}
#pragma maek  浏览模式
-(void)styleseleAction{
  
    if ([self.meetShow isEqualToString:@"1"]) {
        self.meetShow =@"0";
        [self.tableView reloadData];
        [self.view addSubview:self.webviews];

    }else{
        self.meetShow =@"1";
        [self.view addSubview:self.tableView];
        self.webviews = nil;

    }
    

    
}
#pragma mark 关注
- (void)didCollectBtn{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,meetingbaom];
    NSArray *keysArray = @[@"sessionId",@"meetingId"];
    NSArray *valueArray = @[sessionIding,self.huiyiID];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString*retcode= [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            _status = data[@"data"];
            UIButton *kButton = (UIButton *)[self.view viewWithTag:10];
            if ([_status isEqualToString:@"0"]) {
                kButton.selected = NO ;
//                  [kButton setTitle:@"关注" forState:normal];
            }else{
                kButton.selected = YES;
//                kButton.backgroundColor = [UIColor lightGrayColor];
//                [kButton setTitle:@"取消关注" forState:normal];
            }
            
            [kButton setTitleEdgeInsets:UIEdgeInsetsMake(kButton.imageView.frame.size.height +8,-kButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
            [kButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0.0,0.0, -kButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
            if (self.refershList) {
                self.refershList(_status);
            }
        }else{
            
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
    
}
-(void)makeSelectView{
    
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
