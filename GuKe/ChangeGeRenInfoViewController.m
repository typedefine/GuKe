//
//  ChangeGeRenInfoViewController.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ChangeGeRenInfoViewController.h"

@interface ChangeGeRenInfoViewController ()<UITextViewDelegate>{
    UITextView *textVie;
    UILabel *plaerLab;//群公告下面输入框的占位符
    NSString *jianjieStr;

}

@end

@implementation ChangeGeRenInfoViewController

- (instancetype)initWithStyle:(selectStyle)style{
    self = [super init];
    if (self) {
        self.style = &(style);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改个人信息";
    self.view.backgroundColor = SetColor(0xf0f0f0);
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKNeedView)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    [self makeChangeGroup];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 导航栏右侧按钮点击事件
- (void)onClickedOKNeedView{
    if ([Utile stringIsNil:jianjieStr]) {
        [self showHint:@"请输入个人简介"];
    }else{
        self.returnJIan(jianjieStr);
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}
#pragma mark 添加textview
- (void)makeChangeGroup{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 190)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    textVie = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, ScreenWidth - 50, 160)];
    textVie.textColor = titColor;
    textVie.font = [UIFont systemFontOfSize:16];
    textVie.textColor = titColor;
    textVie.font = Font14;
    textVie.delegate = self;
    [backView addSubview:textVie];
    
    
    plaerLab = [[UILabel alloc]init];
    plaerLab.textColor = [UIColor grayColor];
    plaerLab.frame = CGRectMake(0, 0, ScreenWidth - 50, 40);
    plaerLab.numberOfLines = 0;
    plaerLab.font = Font15;
    plaerLab.text = [NSString stringWithFormat:@"请编辑个人简介：及从医历史经验等（字数限制为500字以内）"];
    plaerLab.backgroundColor = [UIColor clearColor];
    [textVie addSubview:plaerLab];
    
    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+ 50, ScreenWidth, 20)];
    labels.textColor = SetColor(0xcccccc);
    labels.text = @"请填写您的个人简介，让更多的人了解您~";
    labels.textAlignment = NSTextAlignmentCenter;
    labels.font = Font15;
    [self.view addSubview:labels];
    
}
#pragma mark textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    plaerLab.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        plaerLab.text = @"请编辑个人简介：及从医历史经验等（字数限制为500字以内）";
        textView.textColor =[UIColor grayColor];
    }else{
        plaerLab.text = @"";
        jianjieStr = textView.text;
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    jianjieStr = textView.text;
}
#pragma mark 限制输入文字的个数
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectRange = [textView markedTextRange];
        if (!selectRange) {
            if (toBeString.length > 500) {
                textView.text = [toBeString substringToIndex:50];
            }
        }else{
            
        }
    }else{
        if (toBeString.length > 500) {
            textView.text = [toBeString substringToIndex:50];
        }
    }
}

- (int)convertToInt:(NSString *)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    for (int i=0; i< [strtemp length]; i++) {
        int a = [strtemp characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) { //判断是否为中文
            strlength += 2;
        }
    }
    return strlength;
}


#pragma mark textfield delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textVie resignFirstResponder];
    return YES;
}

- (void)returnJInaJIe:(returnJianJie)block{
    self.returnJIan = block;
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
