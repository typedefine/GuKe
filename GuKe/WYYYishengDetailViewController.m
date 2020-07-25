//
//  WYYYishengDetailViewController.m
//  GuKe
//
//  Created by yu on 2018/1/17.
//  Copyright © 2018年 shangyukeji. All rights reserved.
//
#import "ChatViewController.h"
#import "WYYYishengDetailViewController.h"
#import "WYYQunLiaoOneTableViewCell.h"
#import "WYYYiShengOneTableViewCell.h"
#import "WYYYiShengTwoTableViewCell.h"
@interface WYYYishengDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    UITableView *detailTableview;
    NSArray *titleaRR;
    NSDictionary *detailDic;
    NSArray *detailArr;//存放姓名，医院，科室，职称的数组
    CGRect heightRect;
    NSArray *zhuanchangArr;//存放个人专长
    NSString * IsFrieds; // 0 NO 1 YES
    
    UIView *blackView;//黑色遮罩层
    UIView *whiteView;//白色展示框
    UITextView *textviews;//输入框
    
}

@end

@implementation WYYYishengDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"医生详情";
    IsFrieds = @"0";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    titleaRR = @[@"姓名",@"医院",@"科室",@"职称"];
    [self makeAddTableview];
    [self yishengDetail];
    [self makeAddView];
    // Do any additional setup after loading the view.
}
#pragma mark  患者好友申请
- (void)makeData{
    if ([self.deleteStr isEqualToString:@"1"]) {
        //删除好友
        NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,userpatienthuanxindeletefriend];
        NSArray *keysArray = @[@"sessionId",@"doctorhuanId"];
        NSArray *valueArray = @[sessionIding,[detailDic objectForKey:@"doctorhuanId"]];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
        [self showHudInView:self.view hint:nil];
        [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
            [self hideHud];
            NSLog(@"删除好友%@",data);
            NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
            if ([retcode isEqualToString:@"0000"]) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else{
                [self showHint:data[@"message"]];
            }
        } failure:^(NSError *error) {
            [self hideHud];
            NSLog(@"删除好友%@",error);
        }];
    }else if([IsFrieds isEqualToString:@"0"]){
        blackView.hidden = NO;
        whiteView.hidden = NO;
        
    }else{

       
        if (detailArr.count >  1) {
            ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter: detailArr[0] conversationType:EMConversationTypeChat];
            chat.doctorId = self.doctorId;
            chat.title = detailArr[0];
            chat.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:chat animated:NO];
            

        }
    }
    
    
}
- (void)makeAddView{
    
    
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) ];
    blackView.alpha = 0.3;
    blackView.backgroundColor = [UIColor blackColor];
    blackView.hidden = YES;
    [self.view addSubview:blackView];
    
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(48, 206, ScreenWidth - (48 + 48), 177)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 5;
    [self.view addSubview:whiteView];
    
    UILabel *titlaB = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth - (48 + 48), 17)];
    titlaB.text = [NSString stringWithFormat:@"备注"];
    titlaB.font = [UIFont systemFontOfSize:18];
    titlaB.textColor = SetColor(0x333333);
    titlaB.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:titlaB];
    
    textviews = [[UITextView alloc]initWithFrame:CGRectMake(29, 44, ScreenWidth - (48 + 48) - 29 - 29, 66)];
    textviews.delegate = self;
    textviews.layer.borderWidth = 1;
    textviews.layer.masksToBounds = YES;
    textviews.layer.cornerRadius = 3;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.94, 0.94, 0.94, 1 });
    [textviews.layer setBorderColor:colorref];//边框颜色
    
    textviews.layer.masksToBounds = YES;
    textviews.layer.cornerRadius = 1;
    [whiteView addSubview:textviews];
    
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(29, 123, (ScreenWidth - (48 + 48) - 29 - 29)/2 - 10, 35)];
    btns.layer.masksToBounds = YES;
    btns.layer.cornerRadius = 4;
    btns.backgroundColor = SetColor(0xCCCCCC);
    [btns setTitle:@"取消" forState:normal];
    btns.titleLabel.font =[UIFont systemFontOfSize:15];
    [btns addTarget:self action:@selector(didQuXiao) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btns];
    
    
    UIButton *OKbtns = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-  48 + 10, 123,(ScreenWidth - (48 + 48) - 29 - 29)/2 - 10, 35)];
    OKbtns.layer.masksToBounds = YES;
    OKbtns.layer.cornerRadius =4;
    OKbtns.backgroundColor = greenC;
    [OKbtns setTitle:@"确定" forState:normal];
    OKbtns.titleLabel.font =[UIFont systemFontOfSize:15];
    [OKbtns addTarget:self action:@selector(didQuDing) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:OKbtns];
    whiteView.hidden = YES;
    
    
    
    
    
}
#pragma mark 取消按钮
- (void)didQuXiao{
    whiteView.hidden = YES;
    blackView.hidden = YES;
    
}
#pragma mark 确定按钮
- (void)didQuDing{
    whiteView.hidden = YES;
    blackView.hidden = YES;
    NSString *contentStr;
    if (textviews.text.length == 0) {
        contentStr = @"";
    }else{
        contentStr = textviews.text;
    }
    
     NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctorhuanxinaddHuan];
     NSArray *keysArray = @[@"sessionId",@"doctorhuanId",@"content"];
     NSArray *valueArray = @[sessionIding,[detailDic objectForKey:@"doctorhuanId"],contentStr];
     NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
     [self showHudInView:self.view hint:nil];
     [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
         [self hideHud];
         NSLog(@"患者好友申请%@",data);
         
         NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
         if ([retcode isEqualToString:@"0000"]) {
             
             EMError  *error = [[EMClient sharedClient].contactManager addContact:[detailDic objectForKey:@"doctorhuanId"] message:@"WYY好友申请"];
             
             if (!error) {
                 [self.navigationController popViewControllerAnimated:NO];
             }
             
             
         }else{
             [self showHint:data[@"message"]];
         }
     
     } failure:^(NSError *error) {
     [self hideHud];
     NSLog(@"患者好友申请%@",error);
     }];
    
    
}
#pragma mark 医生详情
- (void)yishengDetail{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,doctordoctor_xq ];
    NSArray *keysArray = @[@"sessionId",@"doctorId"];
    NSArray *valueArray = @[sessionIding,self.doctorId];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        [self hideHud];
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            detailDic = [[NSDictionary alloc]initWithDictionary:data[@"data"]];
            detailArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"doctorName"]],[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"hosptialName"]],[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"deptName"]],[NSString stringWithFormat:@"%@",[detailDic objectForKey:@"titleName"]], nil];
            IsFrieds  = [NSString stringWithFormat:@"%@",data[@"data"][@"friend"]];
            zhuanchangArr = [NSArray arrayWithArray:data[@"data"][@"specialty"]];
            [detailTableview reloadData];
        }
        NSLog(@"医生详情%@",data);
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"医生详情%@",error);
    }];
}
- (void)makeAddTableview{
    if (IS_IPGONE_X) {
        detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 86)style:UITableViewStyleGrouped];
    }else{
        detailTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStyleGrouped];
    }
    detailTableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:detailTableview];
    detailTableview.delegate = self;
    detailTableview.dataSource = self;
    detailTableview.tableFooterView = [[UIView alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 6;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            return 44 + heightRect.size.height;
        }
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 200;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(10, 81, ScreenWidth - 20, 44)];
        btns.backgroundColor = greenC;
        if ([self.deleteStr isEqualToString:@"1"]) {
            [btns setTitle:@"删除好友" forState:normal];
        }else if([IsFrieds isEqualToString:@"0"]){
            [btns setTitle:@"添加好友" forState:normal];
        }else{
            [btns setTitle:@"发消息" forState:normal];

        }
        
        [btns setTitleColor:[UIColor whiteColor] forState:normal];
        [backView addSubview:btns];
        btns.layer.masksToBounds = YES;
        btns.layer.cornerRadius = 22;
        [btns addTarget:self action:@selector(makeData) forControlEvents:UIControlEventTouchUpInside];
        return backView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 4) {
            static NSString *cellIdone = @"cellIdone";
            WYYYiShengOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYYiShengOneTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            CGFloat  whitess = 0 ;
            CGFloat  spaceBtn = 20;
            CGFloat  whiteS = 0;
            for (int a = 0; a < zhuanchangArr.count; a ++ ) {
                UILabel *labesl = [[UILabel alloc]init];
                labesl.text = [NSString stringWithFormat:@"%@",zhuanchangArr[a][@"specialtyId"]];
                labesl.font = [UIFont systemFontOfSize:12];
                labesl.textAlignment = NSTextAlignmentCenter;
                labesl.textColor = greenC;
                labesl.layer.masksToBounds = YES;
                labesl.layer.cornerRadius = 2;
                labesl.layer.borderWidth = 1;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.02, 0.64, 0.48, 1 });
                [labesl.layer setBorderColor:colorref];//边框颜色
                
                
                
                whitess += (whiteS + spaceBtn) ;
                
                CGRect whiteRect = [labesl boundingRectWithInitSize:labesl.frame.size];
                whiteS = whiteRect.size.width + 5;
                
                labesl.frame = CGRectMake(whitess, 0, whiteS+5, 20);
                [cellOne.scrollview addSubview:labesl];
                
                
            }
            cellOne.scrollview.contentSize = CGSizeMake(whitess + whiteS+ 5*zhuanchangArr.count, 0);
            cellOne.titleLab.text = @"专长";
            cellOne.scrollview.hidden = NO;
            cellOne.imgView.hidden = YES;
            return cellOne;
        }else if (indexPath.row == 5){
            static NSString *cellIdone = @"cellIdone";
            WYYYiShengTwoTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYYiShengTwoTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cellOne.imageView.hidden = YES;
            cellOne.personInfo.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"content"]];
            cellOne.personInfo.numberOfLines = 0;
            heightRect = [cellOne.personInfo boundingRectWithInitSize:cellOne.personInfo.frame.size];
            cellOne.personInfo.frame = CGRectMake(16, 34, ScreenWidth - 30, heightRect.size.height);
            
            return cellOne;
        }else{
            static NSString *cellIdone = @"cellIdone";
            WYYQunLiaoOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
            if (!cellOne) {
                cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYQunLiaoOneTableViewCell" owner:self options:nil] lastObject];
                cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cellOne.titleLab.text = titleaRR[indexPath.row];
            cellOne.swBtn.hidden = YES;
            cellOne.detailLab.text = detailArr[indexPath.row];
            return cellOne;
        }
    }else{
        static NSString *cellIdone = @"cellIdone";
        WYYYiShengOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:cellIdone];
        if (!cellOne) {
            cellOne = [[[NSBundle mainBundle]loadNibNamed:@"WYYYiShengOneTableViewCell" owner:self options:nil] lastObject];
            cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cellOne.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgPath,[detailDic objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"头像"]];
        return cellOne;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    blackView.hidden = YES;
    whiteView.hidden = YES;
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
