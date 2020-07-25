//
//  ZJNFalseViewController.m
//  GuKe
//
//  Created by 朱佳男 on 2017/10/28.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZJNFalseViewController.h"

@interface ZJNFalseViewController ()

@end

@implementation ZJNFalseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    if (IS_IPHONE_4_OR_LESS) {
        imageView.image = [UIImage imageNamed:@"640-960"];
    }else if (IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"640-1136"];
    }else if (IS_IPHONE_6){
        imageView.image = [UIImage imageNamed:@"750-1334"];
    }else if (IS_IPHONE_6P){
        imageView.image = [UIImage imageNamed:@"1242-2208"];
    }else{
        imageView.image = [UIImage imageNamed:@"1125-2436"];
    }
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
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
