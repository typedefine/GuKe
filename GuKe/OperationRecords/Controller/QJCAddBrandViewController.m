//
//  QJCAddBrandViewController.m
//  GuKe
//
//  Created by MYMAc on 2019/2/15.
//  Copyright © 2019年 shangyukeji. All rights reserved.
//

#import "QJCAddBrandViewController.h"

@interface QJCAddBrandViewController (){
    NSMutableArray *titlArr;//标题
    NSArray *arrays;
    
    NSMutableArray *dicArr;//存放选中的数据
    NSMutableArray *publicArr;
}


@end

@implementation QJCAddBrandViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌";
    
    dicArr = [NSMutableArray array];
    [dicArr addObjectsFromArray:self.selectArray];
    publicArr = [NSMutableArray array];
    
    for (NSDictionary *dica in self.selectArray) {
        NSString *choseStr = [NSString stringWithFormat:@"%@",[dica objectForKey:@"brandId"]];
        [publicArr addObject:choseStr];
    }
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedView)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.view.backgroundColor = SetColor(0xf0f0f0);
    titlArr = [NSMutableArray array];
    
    [self makeChoseZhuangChang];
    // Do any additional setup after loading the view from its nib.
}
#pragma  mark
- (void)makeChoseZhuangChang{
  
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,shoushusurgeryBrand];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0000"]) {
            
            /*
             brandCompany = "\U516c\U53f8";
             brandId = 1;
             brandName = "\U5047\U80a2";
             */
            arrays =[[NSArray alloc]initWithArray:data[@"data"]];
            
        }
        [self makeAddButton];

        [self hideHud];
        //        [self showHint:data[@"message"]];
    } failure:^(NSError *error) {
        [self hideHud];
    }];
    

    
    
}
#pragma mark 确定
- (void)onClickedView{
    
    if (dicArr.count == 0) {
        return;
        
    }
    
         self.returnZhuan(dicArr);
 
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark add button
- (void)makeAddButton{
    for (int a= 0; a < arrays.count; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(25 + a%3 * ((ScreenWidth - 80)/3 + 15), 20 + a/3 * (43 + 10) , (ScreenWidth - 80)/3 , 43)];
        if (IS_IPHONE_5) {
            btns.titleLabel.font = [UIFont systemFontOfSize:13];
        }else{
            btns.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
        [btns setTitleColor:titColor forState:normal];
        [btns setTitleColor:greenC forState:UIControlStateSelected];
        btns.titleLabel.numberOfLines = 0;
        btns.titleLabel.lineBreakMode = 0;
        btns.tag = a;
        [btns setBackgroundImage:[UIImage imageNamed:@"专长_wbg"] forState:normal];
        [btns setBackgroundImage:[UIImage imageNamed:@"专长-bg"] forState:UIControlStateSelected];
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btns];
        [btns setTitle:arrays[a][@"brandCompany"] forState:normal];
            
            for (int b= 0; b < self.selectArray.count; b ++ ) {
                NSString *nums = [NSString stringWithFormat:@"%@",arrays[a][@"brandId"]];
                NSString *twoNumb = [NSString stringWithFormat:@"%@",self.selectArray[b][@"brandId"]];
                if ([twoNumb isEqualToString:nums]) {
                    btns.selected = YES;
                }else{
                    // btns.selected = NO;
                }
            }
     }
}
#pragma mark 按钮点击事件
- (void)didButton:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    
    if (sender.selected == YES) {
        
        NSString *strings = [NSString stringWithFormat:@"%@",arrays[sender.tag][@"brandId"]];
        BOOL isBool = [publicArr containsObject:strings];
        if (isBool) {
            
        }else{
            NSDictionary * dic = arrays[sender.tag] ;
            [dicArr addObject:dic];
            [publicArr addObject:strings];
        }
    }else{
        NSString *strings = [NSString stringWithFormat:@"%@",arrays[sender.tag][@"brandId"]];
        for (NSDictionary * dicdd in dicArr) {
            
            if ([publicArr containsObject:strings]) {
                [publicArr removeObject:strings];
                [dicArr removeObject:dicdd];
                break ;
            }
        }
    }
}
- (void)returnZhuan:(returnZhuanChang)block{
    self.returnZhuan = block;
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
