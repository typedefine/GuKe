//
//  ShuHouSUFangViewController.m
//  GuKe
//
//  Created by yu on 2017/8/7.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ShuHouSUFangViewController.h"
#import "HuanZheListModel.h"
#import "OperationRecordsViewController.h"
#import "MedicalRecordsViewController.h"
#import "Follow_UpRecordsViewController.h"
#import "AddFollow_UpRecordsViewController.h"
#import "ZJNAddPatientOperationInfoViewController.h"
#import "PatientInfoManageController.h"

@interface ShuHouSUFangViewController ()<UIScrollViewDelegate>{
    UIScrollView *scrollVi;
    UIView *yellowView;
    NSString *styleRight;
    UIBarButtonItem *rightBarItem;
    NSString *doctorName;
    UIImageView *whiteView;
    UIView *heiseView;
}
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIButton *issueButton;
@end

@implementation ShuHouSUFangViewController
-(instancetype)initWithDictionary:(NSDictionary *)patientInfoDic{
    self = [super init];
    if (self) {
        self.infoDic = patientInfoDic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病例";
    styleRight = @"1";
    // 1.把返回文字的标题设置为空字符串(A和B都是UIViewController)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //自定义一个导航条右上角的一个button
    self.issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.issueButton.frame = CGRectMake(0, 0, 54, 30);
    self.issueButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    _issueButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_issueButton addTarget:self action:@selector(onClickedView) forControlEvents:UIControlEventTouchUpInside];
    [_issueButton setImage:[UIImage imageNamed:@"MORE"] forState:UIControlStateNormal];
    
        //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:_issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
    [self initViews];
    [self addShareView];
    // Do any additional setup after loading the view from its nib.
}
-(void)addShareView
{
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithColor:[UIColor blackColor] alpha:0.3];
    [[[UIApplication sharedApplication]keyWindow] addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    
    whiteView  = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 54, 140, 132)];
    whiteView.userInteractionEnabled = YES;
    whiteView.image = [UIImage imageNamed:@"分享背景"];
    [heiseView addSubview:whiteView];
    
    NSArray *imgArr= [NSArray arrayWithObjects:@"分享-微信-好友2",@"分享-微-朋友圈-",@"分享-站内好友",@"分享-收藏", nil];
    NSArray *nameArr = [NSArray arrayWithObjects:@"微信好友",@"微信朋友圈",@"QQ",@"收藏", nil];
    for (int a = 0; a < 3; a ++) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12 + 44*a, 20, 20)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[a]]];
        [whiteView addSubview:img];
        
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+ 5, 12 + 44*a, 100, 20)];
        labels.font = [UIFont systemFontOfSize:16];
        labels.tag = 100+a;
        labels.textColor = titColor;
        labels.text = [NSString stringWithFormat:@"%@",nameArr[a]];
        [whiteView addSubview:labels];
        
        UIView *lineVew = [[UIView alloc]initWithFrame:CGRectMake(10,44 + 44*a, 120, 1)];
        lineVew.backgroundColor = SetColor(0xf0f0f0);
        [whiteView addSubview:lineVew];
        if (a == 2) {
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
    if (sender.tag == 10) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if (sender.tag == 11){
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    else if (sender.tag == 12){
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"骨先生" descr:[NSString stringWithFormat:@"您的好友%@医生给您分享了一个病例，快快查看",doctorName] thumImage:[UIImage imageNamed:@"80"]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@?hospid=%@",requestUrl,fxpatient,self.hospitalID];
    
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
- (void)onClickedView{
    
    if ([styleRight isEqualToString:@"1"]) {
        heiseView.hidden = NO;
    }else if ([styleRight isEqualToString:@"2"]){
        if ([[self.infoDic objectForKey:@"shares"] isEqualToString:@"1"]) {
     
            
            [self showHint:@"您不是主治医师，不能给患者添加手术记录"];
            return ;
        }
        ZJNAddPatientOperationInfoViewController *qng = [[ZJNAddPatientOperationInfoViewController alloc]init];
        qng.patientInfoDic = self.infoDic;
        qng.zhuyuanhao = self.zhuyuanhao;
        qng.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:qng animated:NO];
      
    }else if ([styleRight isEqualToString:@"3"]){
        if ([[self.infoDic objectForKey:@"shares"] isEqualToString:@"1"]) {
            [self showHint:@"您不是主治医师，不能给患者添加手术记录"];

            return ;
        }

        AddFollow_UpRecordsViewController *shu = [[AddFollow_UpRecordsViewController alloc]init];
        shu.status = [NSString stringWithFormat:@"3"];
        shu.infoDic = self.infoDic;
        shu.hopitalNumbers = self.zhuyuanhao;
        shu.hospitalID = [[NSUserDefaults standardUserDefaults]objectForKey:@"hospitalnumbar"];
        shu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shu animated:NO];
    }
    
}
- (void)initViews
{
    NSArray *titleArr = [NSArray arrayWithObjects:@"就诊记录",@"手术记录",@"随访记录", @"信息管理", nil];
    for (int a = 0; a < titleArr.count; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(15 + ((ScreenWidth - 120)/4 + 30)* a, 0, (ScreenWidth - 120)/4, 39)];
        [btns setTitle:titleArr[a] forState:normal];
        [btns setTitleColor:titColor forState:normal];
        [btns setTitleColor:greenC forState:UIControlStateSelected];
        [btns addTarget:self action:@selector(clickedTopButton:) forControlEvents:UIControlEventTouchUpInside];
        btns.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:btns];
        btns.tag =  10 + a;
        if (a == self.numbers) {
            btns.selected = YES;
            self.selectBtn = btns;
        }
        
    }
    yellowView = [[UIView alloc]initWithFrame:[self configureIndicatorFrameAtIndex:self.numbers]];
    yellowView.backgroundColor = greenC;
    [self.view addSubview:yellowView];
    
    scrollVi = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 64 - 40)];
    scrollVi.delegate = self;
    scrollVi.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight - 64 - 40);
    scrollVi.pagingEnabled = YES;
    [self.view addSubview:scrollVi];
    
    [scrollVi setContentOffset:CGPointMake(ScreenWidth*self.numbers, 0) animated:NO];
    
    MedicalRecordsViewController *view = [[MedicalRecordsViewController alloc]initWithDictionary:self.infoDic];
    view.view.frame = CGRectMake(0, 0, ScreenWidth, scrollVi.frame.size.height);
    view.backHospitalIdBlock = ^(NSDictionary *infoDic) {
        self.hospitalID = infoDic[@"id"];
        doctorName = infoDic[@"name"];
    };
    [scrollVi addSubview:view.view];
    [self addChildViewController:view];
    
    OperationRecordsViewController *operationRecordsVC = [[OperationRecordsViewController alloc]initWithDictionary:self.infoDic];
    operationRecordsVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, scrollVi.frame.size.height);
    [scrollVi addSubview:operationRecordsVC.view];
    [self addChildViewController:operationRecordsVC];
    
    Follow_UpRecordsViewController *followViewC = [[Follow_UpRecordsViewController alloc]initWithDictionary:self.infoDic];
    followViewC.view.frame = CGRectMake(ScreenWidth *2, 0, ScreenWidth, scrollVi.frame.size.height);
    [scrollVi addSubview:followViewC.view];
    [self addChildViewController:followViewC];
    
    PatientInfoManageController *infoManageVC = [[PatientInfoManageController alloc] init];
    infoManageVC.view.frame = CGRectMake(ScreenWidth *3, 0, ScreenWidth, scrollVi.frame.size.height);
    [scrollVi addSubview:infoManageVC.view];
    [self addChildViewController:infoManageVC];
    
}

- (CGRect)configureIndicatorFrameAtIndex:(NSInteger)index
{
    return CGRectMake(15 + ((ScreenWidth - 120)/4 + 30)* index , 39, (ScreenWidth - 120)/4, 1);
}

#pragma mark 就诊记录 手术记录 随访记录
- (void)clickedTopButton:(UIButton *)sender{
    sender.selected =! sender.selected;
    if (sender != _selectBtn) {
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
    }else{
        self.selectBtn.selected = YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        scrollVi.contentOffset = CGPointMake(ScreenWidth * (sender.tag - 10), 0);
        yellowView.frame = [self configureIndicatorFrameAtIndex:sender.tag - 10];
        
    }];
    
    if (sender.tag == 10) {
        

        styleRight = [NSString stringWithFormat:@"1"];
        [self.issueButton setImage:[UIImage imageNamed:@"MORE"] forState:UIControlStateNormal];
    }else if (sender.tag == 11){
        

        styleRight = [NSString stringWithFormat:@"2"];
        [self.issueButton setImage:[UIImage imageNamed:@"就诊记录_添加"] forState:UIControlStateNormal];
    }else if (sender.tag == 12){
        

        styleRight = [NSString stringWithFormat:@"3"];
        [self.issueButton setImage:[UIImage imageNamed:@"就诊记录_添加"] forState:UIControlStateNormal];
        [self.issueButton setTitle:nil forState:UIControlStateNormal];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != scrollVi) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x/ScreenWidth;
    if (index == 0) {

        styleRight = [NSString stringWithFormat:@"1"];
        [self.issueButton setImage:[UIImage imageNamed:@"MORE"] forState:UIControlStateNormal];
    }else if (index == 1){

        styleRight = [NSString stringWithFormat:@"2"];
        [self.issueButton setImage:[UIImage imageNamed:@"就诊记录_添加"] forState:UIControlStateNormal];
    }else if (index == 2){

        styleRight = [NSString stringWithFormat:@"3"];
        [self.issueButton setImage:[UIImage imageNamed:@"就诊记录_添加"] forState:UIControlStateNormal];
    }
    
    UIButton *btnss = (UIButton *)[self.view viewWithTag:index +  10];
    self.selectBtn.selected = NO;
    btnss.selected = YES;
    self.selectBtn = btnss;
    [UIView animateWithDuration:0.3 animations:^{
        yellowView.frame = [self configureIndicatorFrameAtIndex:index];
    }];
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
