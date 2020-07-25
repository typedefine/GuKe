//
//  ForgetMiMaViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ForgetMiMaViewController.h"
#import "LoginViewController.h"
#import "CountButton.h"
@interface ForgetMiMaViewController ()<UITextFieldDelegate>{
    UITextField *phoneText;
    UITextField *yanText;
    UITextField *miText;
    CountButton * yanzhengbutons;
}

@end

@implementation ForgetMiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    views.backgroundColor = SetColor(0x06a27b);
    [self.view addSubview:views];
    
    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 50, 20, 100, 44)];
    labels.text = [NSString stringWithFormat:@"重置密码"];
    labels.textAlignment = NSTextAlignmentCenter;
    labels.font = [UIFont systemFontOfSize:18];
    labels.textColor = [UIColor whiteColor];
    [views addSubview:labels];
    
    UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [btns setImage:[UIImage imageNamed:@"backanniu"] forState:normal];
    [btns addTarget:self action:@selector(didBackButton) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:btns];
    
    [self makeAddView];

    // Do any additional setup after loading the view from its nib.
}

- (void)makeAddView{
    UIView *greyView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 12)];
    greyView.backgroundColor =SetColor(0xf0f0f0);
    [self.view addSubview:greyView];
    
    //
    UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30 + 64, 20, 20)];
    imageOne.image = [UIImage imageNamed:@"iphone"];
    [self.view addSubview:imageOne];
    
    phoneText = [[UITextField alloc]initWithFrame:CGRectMake(40, 30+ 54, ScreenWidth-60, 40)];
    phoneText.delegate = self;
    phoneText.placeholder = @"请输入您的手机号码";
    [self.view addSubview:phoneText];
    
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(10, 60+ 64, ScreenWidth, 1)];
    lineOne.backgroundColor = SetColor(0xe0e0e0);
    [self.view addSubview:lineOne];
    
    //
    UIImageView *imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 90+ 64, 20, 20)];
    imageTwo.image = [UIImage imageNamed:@"ver"];
    [self.view addSubview:imageTwo];
    
    yanText = [[UITextField alloc]initWithFrame:CGRectMake(40, 90+ 54, ScreenWidth-160, 40)];
    yanText.delegate = self;
    yanText.textColor = detailTextColor;
    yanText.placeholder = @"请输入短信验证码";
    [self.view addSubview:yanText];
    
     yanzhengbutons = [[CountButton alloc]initWithFrame:CGRectMake(ScreenWidth - 150, 90+ 54, 130, 40)];
    yanzhengbutons.titleLabel.font = [UIFont systemFontOfSize:16];
    [yanzhengbutons addTarget:self action:@selector(didyanzhengmaBtn) forControlEvents:UIControlEventTouchUpInside];
    [yanzhengbutons setTitle:@"| 获取验证码" forState:normal];
    [yanzhengbutons setTitleColor:SetColor(0xcccccc) forState:normal];
    [self.view addSubview:yanzhengbutons];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(10, 120+ 64, ScreenWidth, 1)];
    lineTwo.backgroundColor = SetColor(0xe0e0e0);
    [self.view addSubview:lineTwo];
    
    //
    UIImageView *imageThree = [[UIImageView alloc]initWithFrame:CGRectMake(10, 150+ 64, 20, 20)];
    imageThree.image = [UIImage imageNamed:@"password"];
    [self.view addSubview:imageThree];
    
    miText = [[UITextField alloc]initWithFrame:CGRectMake(40, 150+ 54, ScreenWidth-60, 40)];
    miText.delegate = self;
    miText.textColor = detailTextColor;
    miText.placeholder = @"请输入不少于6位的密码";
    [self.view addSubview:miText];
    
    UIView *lineThree = [[UIView alloc]initWithFrame:CGRectMake(10, 180+ 64, ScreenWidth, 1)];
    lineThree.backgroundColor = SetColor(0xe0e0e0);
    [self.view addSubview:lineThree];


    UIButton *zhuceBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 300, ScreenWidth - 60, 42)];
    [zhuceBtn setTitle:@"提交" forState:normal];
    zhuceBtn.backgroundColor = SetColor(0x06a27b);
    zhuceBtn.layer.masksToBounds = YES;
    zhuceBtn.layer.cornerRadius = 20;
    [zhuceBtn setTitleColor:[UIColor whiteColor] forState:normal];
    [zhuceBtn addTarget:self action:@selector(didzhuceButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuceBtn];
    
}
#pragma mark 返回按钮点击事件
- (void)didBackButton{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark 提交按钮点击事件
- (void)didzhuceButton{
    if ([self stringIsNil:phoneText.text]) {
        [self showHint:@"请输入手机号码!"];
        return;
    }else if ([self stringIsNil:yanText.text]){
        [self showHint:@"请输入验证码!"];
        return;
    }else if([self stringIsNil:miText.text]){
        [self showHint:@"请输入密码!"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,resetlist];
    NSArray *keysArray = @[@"phone",@"pwd",@"code"];
    NSArray *valueArray = @[phoneText.text,miText.text,yanText.text];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            
            LoginViewController *loginen = [[LoginViewController alloc]init];
            [self presentViewController:loginen animated:NO completion:nil];
        }else{
           // [self showHint:data[@"message"]];
        }
        [self showHint:data[@"message"]];
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
#pragma mark 获取验证码按钮点击事件
- (void)didyanzhengmaBtn{
    if ([self stringIsNil:phoneText.text]) {
        [self showHint:@"输入手机号码"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,appsms];
    NSArray *keysArray = @[@"phone",@"smsType"];
    NSArray *valueArray = @[phoneText.text,@"resetPassword"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            [yanzhengbutons startTime];

        }else{
           // [self showHint:data[@"message"]];
        }
        [self showHint:data[@"message"]];
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"%@",error);
    }];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
