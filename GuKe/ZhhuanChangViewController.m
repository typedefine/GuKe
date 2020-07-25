//
//  ZhhuanChangViewController.m
//  GuKe
//
//  Created by yu on 2017/8/3.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ZhhuanChangViewController.h"
#import "ChooseMoreItems.h"
#import "Details.h"

@interface ZhhuanChangViewController (){
    NSMutableArray *titlArr;//标题
    NSArray *arrays;

    NSMutableArray *dicArr;//存放选中的数据
    NSMutableArray *publicArr;
    
    
}
@property (strong, nonatomic)ChooseMoreItems *SelectDataView;/**<多选页面*/


@end

@implementation ZhhuanChangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.typeStr isEqualToString:@"1"]){
        self.title = @"关节列表";
    }else{
        self.title = @"选特长";
    }
    dicArr = [NSMutableArray array];
    [dicArr addObjectsFromArray:self.selectArray];
 
    publicArr = [NSMutableArray array];
    
    for (NSDictionary *dica in self.selectArray) {
        NSString *choseStr = [NSString stringWithFormat:@"%@",[dica objectForKey:@"uid"]];
        [publicArr addObject:choseStr];
    }
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedView)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.view.backgroundColor = SetColor(0xf0f0f0);
    titlArr = [NSMutableArray array];
    
    [self makeChoseZhuangChang];
    // Do any additional setup after loading the view from its nib.
}
#pragma  mark 公用专长
- (void)makeChoseZhuangChang{
    NSString *urlString;
    MJWeakSelf;
    
    if ([self.typeStr isEqualToString:@"1"]) {
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,jointslist];
    }else if([self.typeStr isEqualToString:@"2"]){
        urlString = [NSString stringWithFormat:@"%@%@",requestUrl,specialtylist];
    }
    
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
        NSLog(@"公用专长%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            arrays = [NSArray arrayWithArray:data[@"data"]];
          if ([self.typeStr isEqualToString:@"1"]) {
            self.SelectDataView = [[ChooseMoreItems alloc]init];
            self.SelectDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight );
            self.SelectDataView.didSelectItem = ^(NSArray *SelectModelArray) {
                NSLog(@"%@",SelectModelArray);
                [dicArr removeAllObjects];

                for (Details * selectmodel in SelectModelArray) {
                    NSMutableDictionary  * dic  =[[NSMutableDictionary alloc]init];
                    [dic setValue:selectmodel.jointsName forKey:@"jointsName"];
                    [dic setValue:selectmodel.uid forKey:@"uid"];
                    [dic setValue:@"3" forKey:@"level"];
                    [dicArr addObject:dic];
                }
                
            };
            [self.view  addSubview:self.SelectDataView];
            [self.SelectDataView makeViewWithData:arrays AndSelectArray:self.selectArray];
           }else{
                      [self makeAddButton];
          }
        }else{
            [self showHint:data[@"message"]];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"公用专长%@",error);
    }];
}

#pragma mark 确定
- (void)onClickedView{
    
    if (dicArr.count == 0) {
        [self showHint:@"请至少选择一项"];
        return;
        
    }

    if ([_typeStr isEqualToString:@"1"]) {
        self.returnZhuan(dicArr);
    }else{
        self.returnChang(dicArr);
    }
    
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
        
        if ([self.typeStr isEqualToString:@"1"]) {
            [btns setTitle:arrays[a][@"jointsName"] forState:normal];
            
            for (int b= 0; b < self.selectArray.count; b ++ ) {
                NSString *nums = [NSString stringWithFormat:@"%@",arrays[a][@"uid"]];
                NSString *twoNumb = [NSString stringWithFormat:@"%@",self.selectArray[b][@"uid"]];
                if ([twoNumb isEqualToString:nums]) {
                    btns.selected = YES;
                }else{
                    btns.selected = NO;
                }
            }
        }else{
            [btns setTitle:arrays[a][@"specialtyName"] forState:normal];
            
            for (int b= 0; b < self.selectArray.count; b ++ ) {
                NSString *nums = [NSString stringWithFormat:@"%@",arrays[a][@"uid"]];
                NSString *twoNumbs = [NSString stringWithFormat:@"%@",self.selectArray[b][@"uid"]];
                if ([twoNumbs isEqualToString:nums]) {
                    btns.selected = YES;
                }else{
                   // btns.selected = NO;
                }
            }
        }
    }
}
#pragma mark 按钮点击事件
- (void)didButton:(UIButton *)sender{
    sender.selected =! sender.selected;
    if (sender.selected == YES) {
        
        
        NSString *strings = [NSString stringWithFormat:@"%@",arrays[sender.tag][@"uid"]];
        
        
        BOOL isBool = [publicArr containsObject:strings];
        
        if (isBool) {
            
        }else{
            [dicArr addObject:arrays[sender.tag]];
        }
    }else{
        [dicArr removeObject:arrays[sender.tag]];
    }
    
}

- (void)returnZhuan:(returnZhuanChang)block{
    self.returnZhuan = block;
}
- (void)returnchang:(returnZhuanPerinfo)block{
    self.returnChang = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 /*
 jointsName = "\U8170\U690e";
 level = 3;
 parentUid = 1;
 uid = 8;

 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
