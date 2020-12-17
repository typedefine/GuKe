//
//  GuKeNavigationViewController.m
//  GuKe
//
//  Created by yu on 2017/8/1.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "GuKeNavigationViewController.h"

@interface GuKeNavigationViewController ()

@end

@implementation GuKeNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = greenC;
    bar.layer.borderColor = [UIColor clearColor].CGColor;
    bar.layer.borderWidth = 1.5f;
    bar.translucent = NO;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    //设置导航栏标题的字体颜色和大小
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    NSString *version = [UIDevice currentDevice].systemVersion;
    
//    UIImage *backImage = [UIImage imageNamed:@"backanniu"];
    
//    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    if (version.doubleValue < 11) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    }else{
    
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0)forBarMetrics:UIBarMetricsDefault];
    }
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];//设置背景
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
//    [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    

    // Do any additional setup after loading the view from its nib.
}

//- (UIImage *)createImageWithColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


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
