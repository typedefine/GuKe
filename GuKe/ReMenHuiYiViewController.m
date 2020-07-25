//
//  ReMenHuiYiViewController.m
//  GuKe
//
//  Created by yu on 2017/8/18.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ReMenHuiYiViewController.h"
#import "MainHuiYiViewController.h"
#import "HuiyiTableViewCell.h"
#import "ZJNSignUpMeetingViewController.h"
#import "ZJNHotMeetingListModel.h"
@interface ReMenHuiYiViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField *searchText;
    NSString *meetingName;//搜索关键字
    UITableView *huiyiTable;
    NSMutableArray *baomingArr;
    NSInteger page ;
    NSDate * comeDate;//进入模块的时间
}
@property (nonatomic,strong)UIButton *issueButton;//右侧按钮
@end

@implementation ReMenHuiYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    baomingArr = [NSMutableArray array];
    meetingName = @"";
    comeDate =[NSDate date];
    // 1.把返回文字的标题设置为空字符串(A和B都是UIViewController)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.issueButton.frame = CGRectMake(0, 0, 54, 30);
    self.issueButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    //[_issueButton setTitle:@"添加" forState:UIControlStateNormal];
    [_issueButton setImage:[UIImage imageNamed:@"❤"] forState:normal];
    _issueButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_issueButton addTarget:self action:@selector(onClickedOKNeedView) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:_issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
    
    [self makeADDView];
    [self makeRequestData];
    // Do any additional setup after loading the view from its nib.
}
- (void)onClickedOKNeedView{
    MainHuiYiViewController *main = [[MainHuiYiViewController alloc]init];
    main.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:main animated:NO];
}
#pragma mark data
- (void)makeRequestData{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,meetinglist];
    NSArray *keysArray = @[@"sessionid",@"meetingName",@"meetingModel",@"page"];
    NSArray *valueArray = @[sessionIding,meetingName,self.mettingMoodel,[NSString stringWithFormat:@"%d",page]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"热门会议%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *dataArr = data[@"data"];
            if (page ==1) {
                [baomingArr  removeAllObjects];
            }
            for (NSDictionary *dic in dataArr) {
                ZJNHotMeetingListModel *model = [ZJNHotMeetingListModel yy_modelWithDictionary:dic];
                [baomingArr addObject:model];
            }
        }
        [huiyiTable reloadData];
        [self hideHud];
        [huiyiTable.mj_footer endRefreshing];
        [huiyiTable.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [huiyiTable.mj_footer endRefreshing];
        [huiyiTable.mj_header endRefreshing];
        [self hideHud];
        NSLog(@"热门会议%@",error);
    }];
    
}
#pragma mark add view
- (void)makeADDView{
    //搜索框
    UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 30)];
    viewBack.backgroundColor = SetColor(0xeae9e9);
    viewBack.layer.masksToBounds = YES;
    viewBack.layer.cornerRadius = 15;
    [self.view addSubview:viewBack];
    
    UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    images.image = [UIImage imageNamed:@"搜索-搜索"];
    [viewBack addSubview:images];
    
    searchText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(images.frame) + 5, 0, 200, 30)];
    searchText.delegate = self;
    searchText.textColor = SetColor(0xb3b3b3);
    searchText.placeholder = @"搜索热门会议";
    searchText.font = Font12;
    [viewBack addSubview:searchText];
    
    
    UIButton *labelsa = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70,10 , 70, 30)];
    labelsa.titleLabel.font = Font14;
    [labelsa setTitle:@"搜索" forState:normal];
  
    [labelsa setTitleColor:titColor forState:normal];
    [labelsa addTarget:self action:@selector(didSouSuoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelsa];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 10)];
    lineView.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:lineView];

    huiyiTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, ScreenWidth,ScreenHeight-NavBarHeight-54-TabbarAddHeight) style:UITableViewStyleGrouped];
    huiyiTable.delegate = self;
    huiyiTable.dataSource = self;
    huiyiTable.separatorStyle = UITableViewCellAccessoryNone;
    huiyiTable.tableFooterView = [[UIView alloc]init];
    huiyiTable.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page == 1;
        [self makeRequestData ];
    }];
    huiyiTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self makeRequestData];
    }];
    [self.view addSubview:huiyiTable];
    
}
#pragma mark 搜索
- (void)didSouSuoButton{
    [searchText resignFirstResponder];
    [baomingArr removeAllObjects];
    page ==1;
    [self makeRequestData];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return baomingArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92+ScreenWidth*(3/5.0);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdter = @"cellId";
    HuiyiTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
    if (!cellTwo) {
        cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"HuiyiTableViewCell" owner:self options:nil] lastObject];
        cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZJNHotMeetingListModel *model = baomingArr[indexPath.section];
    [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,model.image]] placeholderImage:[UIImage imageNamed:@"bannerImage"]];
    cellTwo.titleLab.text = [NSString stringWithFormat:@"%@",model.meetingName];
    cellTwo.namelAB.text = [NSString stringWithFormat:@"%@",model.createUser];
    cellTwo.TimeLab.text = [NSString stringWithFormat:@"%@",model.beginTime];
    cellTwo.addressLab.text = [NSString stringWithFormat:@"%@",model.site];
    NSString *liveStr = [NSString stringWithFormat:@"%@",model.live];
//  liveStr（判断是直播或者是回放）  1  直播   2 回放 其他状态不显示按钮
    if ([liveStr isEqualToString:@"1"]){
         cellTwo.liveImageView.image = [UIImage imageNamed:@"直播中"];
    
    }else if ([liveStr isEqualToString:@"2"]){
        cellTwo.liveImageView.image = [UIImage imageNamed:@"回放"];
//         回放的时候，如果 payState =  0  隐藏回放按钮
        if([model.payState isEqualToString:@"0"]){
            cellTwo.liveImageView.hidden = YES ;
        }
    }else{
//     liveStr   其他状态不显示按钮
    }
    return cellTwo;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    ZJNHotMeetingListModel *model = baomingArr[indexPath.section];
   
     ZJNSignUpMeetingViewController *yi = [[ZJNSignUpMeetingViewController alloc]init];
    yi.status = model.stats;
    yi.huiyiID = model.uid;
    yi.live = model.live;
    yi.urlStr  = [NSString stringWithFormat:@"%@app/meeting/type_show.json?uid=%@",requestUrl,model.uid];
    yi.specialAllow = model.specialAllow;
    yi.meetingModel = model.meetingModel;
    yi.meetShow = model.meetShow;
    yi.content = model.content;
    yi.meetShow = model.meetShow;
    yi.switchState = model.switchState;
    yi.shareImagePath = model.image;
    yi.sharetitle = model.meetingName;
    yi.payState = model.payState;
    yi.refershList = ^(NSString *type) {
        model.stats = type;
    };
    yi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yi animated:NO];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    meetingName = textField.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)navigationShouldPopOnBackButton{

    NSDate * Nowdate =[NSDate date];
    
    NSTimeInterval  time =[Nowdate timeIntervalSinceDate:comeDate];
    if([self.mettingMoodel isEqualToString:@"0"]){
        [moduleDate ShareModuleDate].TrainingLength = time;
        
    }else{
        [moduleDate ShareModuleDate].MeetingLength = time;
      }
    
    return  YES ;
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
