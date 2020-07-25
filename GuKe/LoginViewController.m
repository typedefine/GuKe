//
//  LoginViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "LoginViewController.h"
#import "GuKeViewController.h"
#import "ForgetMiMaViewController.h"
#import "ZYNetworkAccessibity.h"
#import "CountButton.h"
@interface LoginViewController ()<UITextFieldDelegate>{
    UILabel *titleLab;//页面标题
    UIView *blackView;//黑色遮罩层
    UIView *whiteView;//白色图层
    
    CountButton *yanzhengbutons ;
    UIView *loginView;//登录图层
    UIImageView *oneView;//白色三角
    
    UIView *zhuceView;//注册图层
    UIImageView *twoView;//白色三角
    
    //登录
    UITextField *PhoneText;
    UITextField *MimAText;
    NSString    *phoneStr;
    NSString    *pwdStr;
    //注册
    UITextField *Phones;
    UITextField *yanText;
    UITextField *mimaText;
    
    UIImageView *imagelogin;
    UIImageView *imagesss;
    NSUserDefaults *defaults;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    [self makeAddView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:ZYNetworkAccessibityChangedNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:ZYNetworkAccessibityChangedNotification];
    
}
#pragma mark view 
- (void)makeAddView{
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , 200)];
    imageView.image = [UIImage imageNamed:@"login_bg"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
        
    //标题
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = [NSString stringWithFormat:@"医生登录"];
    [self.view addSubview:titleLab];

    //登录
    UIButton *btnOne = [[UIButton alloc]initWithFrame:CGRectMake(0, 138, ScreenWidth/2, 30)];
    [btnOne setTitleColor:[UIColor whiteColor] forState:normal];
    [btnOne setTitle:@"登录" forState:normal];
    btnOne.titleLabel.font = Font15;
    [btnOne addTarget:self action:@selector(didDengluButtonOne:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnOne];
    
    
    
    //注册
    UIButton *zhuceBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 138, ScreenWidth/2, 30)];
    [zhuceBtn setTitle:@"注册" forState:normal];
    [zhuceBtn setTitleColor:[UIColor whiteColor] forState:normal];
    zhuceBtn.titleLabel.font = Font15;
    [zhuceBtn addTarget:self action:@selector(didZhuCeButtonTwo) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:zhuceBtn];
    
    //登录图层
    [self makeAddLoginView];
    [self makeAddZhuCeView];
}
#pragma mark 添加登录view
- (void)makeAddLoginView{
    oneView = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth/4 - 7, 170, 15, 10)];
    oneView.image = [UIImage imageNamed:@"login_current"];
    [self.view addSubview:oneView];
    
    imagelogin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 250)];
    imagelogin.image = [UIImage imageNamed:@"渐变_bg"];
    [self.view addSubview:imagelogin];
    
    
    //背景图
    loginView = [[UIView alloc]initWithFrame:CGRectMake(10, 180, ScreenWidth - 20, 250)];
    loginView.backgroundColor = [UIColor whiteColor];
    loginView.layer.masksToBounds = YES;
    loginView.layer.cornerRadius = 8;
    [self.view addSubview:loginView];
    
    //手机号
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 20, 20)];
    phoneImg.image = [UIImage imageNamed:@"iphone"];
    [loginView addSubview:phoneImg];
    PhoneText = [[UITextField alloc]initWithFrame:CGRectMake(40, 35, ScreenWidth-60, 40)];
    PhoneText.font = Font14;
    PhoneText.delegate = self;
    PhoneText.textColor = detailTextColor;
    PhoneText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    NSString *userPhones = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"userPhone"]];
    if ([Utile stringIsNilZero:userPhones]) {
        
    }else{
        PhoneText.text = userPhones;
    }
    
    PhoneText.placeholder = [NSString stringWithFormat:@"请输入您的手机号码"];
    [loginView addSubview:PhoneText];
    UIView *lingViewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 75, ScreenWidth - 20, 1)];
    lingViewOne.backgroundColor = SetColor(0xe0e0e0);
    [loginView addSubview:lingViewOne];
    
    //密码
    UIImageView *mimaImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 95, 20, 20)];
    mimaImg.image = [UIImage imageNamed:@"password"];
    [loginView addSubview:mimaImg];
    
    MimAText = [[UITextField alloc]initWithFrame:CGRectMake(40, 85, ScreenWidth-60, 40)];
    MimAText.secureTextEntry = YES;
    MimAText.delegate = self;
    MimAText.textColor = detailTextColor;
    MimAText.font = Font14;
    MimAText.placeholder = [NSString stringWithFormat:@"请输入密码"];
     NSString *pwd = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"passWord"]];
    if (![NSString IsNullStr:pwd]) {
        MimAText.text = pwd;

    }
    [loginView addSubview:MimAText];
    UIView *lingViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 125, ScreenWidth - 20, 1)];
    lingViewTwo.backgroundColor = SetColor(0xe0e0e0);
    [loginView addSubview:lingViewTwo];
    
    //忘记密码按钮
    UIButton *wangjiBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 110, 135, 90, 40)];
    [wangjiBtn setTitle:@"忘记密码?" forState:normal];
    [wangjiBtn setTitleColor:SetColor(0x666666) forState:normal];
    wangjiBtn.titleLabel.font = Font14;
    [wangjiBtn addTarget:self action:@selector(didWangJiButton) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:wangjiBtn];
    
    //登录按钮
    UIButton *dengluBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 195, CGRectGetWidth(loginView.frame) - 60, 44)];
    [dengluBtn setTitle:@"登录" forState:normal];
    dengluBtn.backgroundColor = SetColor(0x06a27b);
    dengluBtn.layer.masksToBounds = YES;
    dengluBtn.layer.cornerRadius = 20;
    dengluBtn.titleLabel.font = Font15;
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:normal];
    [dengluBtn addTarget:self action:@selector(didDengluButton) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:dengluBtn];

}
- (void)makeAddZhuCeView{
    //白色小三角
    twoView = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth/4 * 3 - 7, 170, 15, 10)];
    twoView.image = [UIImage imageNamed:@"login_current"];
    [self.view addSubview:twoView];
    twoView.hidden = YES;
    
    imagesss = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
    imagesss.image = [UIImage imageNamed:@"渐变_bg"];
    [self.view addSubview:imagesss];
    imagesss.hidden = YES;
    
    //
    zhuceView = [[UIView alloc]initWithFrame:CGRectMake(10, 180, ScreenWidth - 20, 300)];
    zhuceView.backgroundColor = [UIColor whiteColor];
    zhuceView.layer.masksToBounds = YES;
    zhuceView.layer.cornerRadius = 8;
    [self.view addSubview:zhuceView];
    zhuceView.hidden = YES;

    //手机号
    UIImageView *phoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 20, 20)];
    phoneImg.image = [UIImage imageNamed:@"iphone"];
    [zhuceView addSubview:phoneImg];
    
    Phones = [[UITextField alloc]initWithFrame:CGRectMake(40, 35, ScreenWidth-60, 40)];
    Phones.textColor = detailTextColor;
    Phones.font = Font14;
    Phones.delegate = self;
    Phones.placeholder = [NSString stringWithFormat:@"请输入您的手机号码"];
    [zhuceView addSubview:Phones];
    
    UIView *lingViewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 75, ScreenWidth - 20, 1)];
    lingViewOne.backgroundColor = SetColor(0xe0e0e0);
    [zhuceView addSubview:lingViewOne];

    //验证码
    UIImageView *yanImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 95, 20, 20)];
    yanImg.image = [UIImage imageNamed:@"ver"];
    [zhuceView addSubview:yanImg];
    yanText = [[UITextField alloc]initWithFrame:CGRectMake(40, 85, ScreenWidth-160, 40)];
    yanText.font = Font14;
    yanText.delegate = self;
    yanText.textColor = detailTextColor;
    yanText.placeholder = [NSString stringWithFormat:@"请输入短信验证码"];
    [zhuceView addSubview:yanText];
    UIView *lingViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 125, ScreenWidth - 20, 1)];
    lingViewTwo.backgroundColor = SetColor(0xe0e0e0);
    [zhuceView addSubview:lingViewTwo];
    
    yanzhengbutons = [[CountButton alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 85, 130, 40)];
    yanzhengbutons.titleLabel.font = [UIFont systemFontOfSize:16];
    [yanzhengbutons addTarget:self action:@selector(didyanzhengmaBtn) forControlEvents:UIControlEventTouchUpInside];
    [yanzhengbutons setTitle:@"获取验证码" forState:normal];
    [yanzhengbutons setTitleColor:SetColor(0xcccccc) forState:normal];
    
    [zhuceView addSubview:yanzhengbutons];

    //密码
    UIImageView *mimaImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 145, 20, 20)];
    mimaImg.image = [UIImage imageNamed:@"password"];
    [zhuceView addSubview:mimaImg];
    
    mimaText = [[UITextField alloc]initWithFrame:CGRectMake(40, 135, ScreenWidth-60, 40)];
    mimaText.secureTextEntry = YES;
    mimaText.font = Font14;
    mimaText.delegate = self;
    mimaText.textColor = detailTextColor;
    mimaText.placeholder = [NSString stringWithFormat:@"请输入不少于6位的密码"];
    [zhuceView addSubview:mimaText];
    
    UIView *lingViewThree = [[UIView alloc]initWithFrame:CGRectMake(0, 175, ScreenWidth - 20, 1)];
    lingViewThree.backgroundColor = SetColor(0xe0e0e0);
    [zhuceView addSubview:lingViewThree];
    
    //注册按钮
    UIButton *zhuceBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 230, CGRectGetWidth(zhuceView.frame) - 60, 42)];
    [zhuceBtn setTitle:@"注册" forState:normal];
    zhuceBtn.backgroundColor = SetColor(0x06a27b);
    zhuceBtn.layer.masksToBounds = YES;
    zhuceBtn.layer.cornerRadius = 20;
    zhuceBtn.titleLabel.font = Font15;
    [zhuceBtn setTitleColor:[UIColor whiteColor] forState:normal];
    [zhuceBtn addTarget:self action:@selector(didzhuceButton) forControlEvents:UIControlEventTouchUpInside];
    [zhuceView addSubview:zhuceBtn];

}
#pragma mark 登录按钮   one
- (void)didDengluButtonOne:(UIButton *)sender{
    titleLab.text = [NSString stringWithFormat:@"医生登录"];
    oneView.hidden = NO;
    loginView.hidden = NO;
    twoView.hidden = YES;
    zhuceView.hidden = YES;
    imagesss.hidden = YES;
    imagelogin.hidden = NO;

}
#pragma mark 登录按钮   提交
- (void)didDengluButton{
    [self.view endEditing:YES];
//    [PhoneText resignFirstResponder];
//    [mimaText resignFirstResponder];
    if (PhoneText.text) {
        phoneStr = [NSString changeNullString:PhoneText.text];
    }else{
        [self showHint:@"请输入手机号码!"];
        return;
    }
    if (MimAText.text) {
        pwdStr = [NSString changeNullString:MimAText.text];
    }else{
        [self showHint:@"请输入密码!"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,logining];
    NSArray *keysArray = @[@"userName",@"pwd"];
    NSArray *valueArray = @[phoneStr,pwdStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
//        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
  
        if ([retcode isEqualToString:@"0"]) {
            
            [defaults setObject:data[@"data"][@"sessionId"] forKey:@"sessionIdUser"];
            
            [defaults setObject:phoneStr forKey:@"userPhone"];
            
            [defaults setObject:pwdStr forKey:@"passWord"];
            
            [defaults setObject:data[@"data"][@"userId"] forKey:@"UserId"];
            
            [defaults setObject:data[@"data"][@"state"] forKey:@"STATE"];//保存认证状态
            [defaults synchronize];
            
            SetChatImgUrl(data[@"data"][@"portrait"]);
            SetChatUserName(data[@"data"][@"nickname"]);
            
            
            Synchronize;
//            NSLog(@"%@",ChatImgUrl);
            [self makeLoginHuanXin:data[@"data"][@"userId"] password:data[@"data"][@"pwd"]];
//            GuKeViewController *viewC = [[GuKeViewController alloc]init];
//            [UIApplication sharedApplication].keyWindow.rootViewController=viewC;
        }else{
            [self showHint:data[@"message"]];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}
//wang start  登录环信
- (void)makeLoginHuanXin:(NSString *)userName password:(NSString *)password{
    EMError *error = [[EMClient sharedClient]loginWithUsername:userName  password:password];
    if (!error) {
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.displayStyle = EMPushDisplayStyleMessageSummary; // 显示消息内容
        // options.displayStyle = EMPushDisplayStyleSimpleBanner // 显示“您有一条新消息”
        EMError *error = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法
        if(!error) {
            // 成功
            NSLog(@"配置成功！ error = %@",error);
        }else {
            // 失败
        }
        NSLog(@"登陆成功！ userName = %@",userName);
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(YES)];
        
    }else{
        
        
        [self hideHud];
        if(error.code == EMErrorUserAlreadyLogin){
            [[EMClient sharedClient]logout:YES];
            [[EMClient sharedClient]loginWithUsername:userName  password:password];

         }
        NSLog(@"%@",error.errorDescription);
        
      
    }
}

#pragma mark 注册按钮   one
- (void)didZhuCeButtonTwo{
    titleLab.text = [NSString stringWithFormat:@"医生注册"];
    twoView.hidden = NO;
    zhuceView.hidden = NO;
    oneView.hidden = YES;
    loginView.hidden = YES;
    imagesss.hidden = NO;
    imagelogin.hidden = YES;
}
#pragma mark 注册按钮   提交
- (void)didzhuceButton{
    if ([self stringIsNil:Phones.text]) {
        [self showHint:@"请输入手机号码!"];
        return;
    }else if ([self stringIsNil:yanText.text]){
        [self showHint:@"请输入验证码!"];
        return;
    }else if([self stringIsNil:mimaText.text]){
        [self showHint:@"请输入密码!"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,appregister];
    NSArray *keysArray = @[@"phone",@"code",@"pwd"];
    NSArray *valueArray = @[Phones.text,yanText.text,mimaText.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            
            PhoneText.text = Phones.text;
            
            titleLab.text = [NSString stringWithFormat:@"医生登录"];
            oneView.hidden = NO;
            imagesss.hidden = YES;
            imagelogin.hidden = NO;
            loginView.hidden = NO;
            twoView.hidden = YES;
            zhuceView.hidden = YES;
        }else{
            [self showHint:data[@"message"]];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
    
}


#pragma mark 判断字符是否为空
- (BOOL)stringIsNil:(NSString *)strings{
    if ([strings isEqualToString:@""]||[strings isEqualToString:@"(null)"]||[strings isEqualToString:@"<null>"]||(strings.length == 0)) {
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark 获取验证码
- (void)didyanzhengmaBtn{
    
    if ([self stringIsNil:Phones.text]) {
        [self showHint:@"输入手机号码"];
        return;
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,appsms];
    NSArray *keysArray = @[@"phone",@"smsType"];
    NSArray *valueArray = @[Phones.text,@"register"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [yanzhengbutons startTime];

        }else{
            //[self showHint:data[@"message"]];
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];
}

#pragma mark 忘记密码按钮
- (void)didWangJiButton{
    NSLog(@"111");
    ForgetMiMaViewController *forget = [[ForgetMiMaViewController alloc]init];
    [self presentViewController:forget animated:NO completion:nil];
}

#pragma mark textfield delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)networkChanged:(NSNotification *)notification {
    
    ZYNetworkAccessibleState state = ZYNetworkAccessibity.currentState;
    
    if (state == ZYNetworkRestricted) {
        NSLog(@"网络权限被关闭");
 
    }
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
