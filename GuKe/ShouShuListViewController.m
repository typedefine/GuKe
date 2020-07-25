//
//  ShouShuListViewController.m
//  GuKe
//
//  Created by yu on 2017/8/25.
//  Copyright © 2017年 shangyukeji. All rights reserved.
//

#import "ShouShuListViewController.h"
#import "WoDeShouShuTableViewCell.h"
#import "ShuHouSUFangViewController.h"
#import "ZJNDatePickerView.h"
#import "ZhhuanChangViewController.h"
@interface ShouShuListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZJNDatePickerDelegate>{
    UITableView *huanZheTable;
    UITextField *searchText;
    NSString *StrSearch;
    NSString *StringOne;
    NSString *StringTwo;
    
    UITableView *tableviewOne;
    
    UIView *heiseView;//黑色遮罩层
    UIView *_backWindowView;
    
    NSInteger number;//分页参数
    NSMutableArray *resourceArr;
    
    NSString *stringOne;//标注类别
    NSString *stringTwo;//标注类型
    NSString *inTime;
    
    NSMutableArray *Arrone;//关节
    NSMutableArray *ArrTwo;//时间
    NSInteger tableNum;
    NSInteger page;//请求患者列表分页
    UILabel * numberLB ; // 显示返回的条数，

    NSMutableArray * selectGuanjieDic;//帅选的关节
}
//@property (nonatomic,strong)DatePickerView *DatePick;
@property (nonatomic,strong)ZJNDatePickerView *DatePick;
@property (nonatomic,strong)UIButton *selectedBtnOne;


@end

@implementation ShouShuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我做过的手术";
    selectGuanjieDic =[[NSMutableArray alloc]init];

    page =  0;
    /*
    //添加
    UIBarButtonItem *rightSharBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(shardBtA)];
    self.navigationItem.rightBarButtonItem = rightSharBt;
    */
    
    resourceArr = [NSMutableArray array];
    Arrone = [NSMutableArray array];
    ArrTwo = [NSMutableArray array];
    
    
    StrSearch = [NSString stringWithFormat:@""];
    stringOne = [NSString stringWithFormat:@""];
    stringTwo = [NSString stringWithFormat:@""];
    inTime = [NSString stringWithFormat:@""];
    
    [self makeTableView];
    [self makeSuiFanglist];
    [self makeGuanjie];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 右上角加号按钮点击事件
- (void)shardBtA{
    
}
#pragma mark 我的手术 已完成
- (void)makeSuiFanglist{
    page++;
 
    NSMutableArray * SeleUidArray =[[NSMutableArray alloc]init];
    for (NSDictionary *SelectDic in selectGuanjieDic) {
        [SeleUidArray addObject:SelectDic[@"uid"]];
    }
    stringOne = [ SeleUidArray componentsJoinedByString:@","];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,surgerylist];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
     NSArray *keysArray = @[@"sessionid",@"patientname",@"jointid",@"time",@"page"];
    NSArray *valueArray = @[sessionIding,StrSearch,stringOne,inTime,pageStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keysArray];
    [self showHudInView:self.view hint:nil];
    [ZJNRequestManager postWithUrlString:urlString parameters:dic success:^(id data) {
        NSLog(@"我的手术 已完成%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            if (page == 1) {
                [resourceArr removeAllObjects];
            }
            if (array.count > 0) {
                
                [resourceArr addObjectsFromArray:array];
                
            }else{
                
                if (resourceArr.count == 0) {
                    [self showHint:@"暂无数据"];
                }else{
                    [self showHint:@"暂无更多数据"];
                }
            }
        }else{
            page --;
            [self showHint:data[@"message"]];
        }
        numberLB.text =[NSString stringWithFormat:@"共有%@条数据",[NSString changeNullString: [NSString stringWithFormat:@"%@",data[@"count"]]]];

        [huanZheTable reloadData];
        [huanZheTable.mj_header endRefreshing];
        [huanZheTable.mj_footer endRefreshing];
        
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
        [huanZheTable.mj_header endRefreshing];
        [huanZheTable.mj_footer endRefreshing];
        NSLog(@"我的手术 已完成%@",error);
    }];
    
}
#pragma mark  关节名称
- (void)makeGuanjie{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",requestUrl,jointslist];
    
    [ZJNRequestManager postWithUrlString:urlString parameters:nil success:^(id data) {
        NSLog(@"关节名称%@",data);
        NSString *retcode = [NSString stringWithFormat:@"%@",data[@"retcode"]];
        if ([retcode isEqualToString:@"0"]) {
            NSArray *array = [NSArray arrayWithArray:data[@"data"]];
            if (array.count > 0) {
                [Arrone addObjectsFromArray:array];
                
                if (array.count > 4) {
                    tableviewOne.frame = CGRectMake(0, 100, ScreenWidth, 44*4);
                }else{
                    tableviewOne.frame = CGRectMake(0, 100, ScreenWidth, 44*array.count);
                }
                
                [tableviewOne reloadData];
            }
        }else{
            [self showHint:data[@"messages"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"关节名称%@",error);
    }];
    
}
#pragma mark add tableview
- (void)makeTableView{
    //搜索框
    UIView *viewBack = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 30)];
    viewBack.backgroundColor = SetColor(0xf0f0f0);
    viewBack.layer.masksToBounds = YES;
    viewBack.layer.cornerRadius = 15;
    [self.view addSubview:viewBack];
    
    UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    images.image = [UIImage imageNamed:@"搜索-搜索"];
    [viewBack addSubview:images];
    
    searchText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(images.frame) + 5, 0, 200, 30)];
    searchText.delegate = self;
    searchText.font = Font12;
    searchText.placeholder = @"搜患者";
    [viewBack addSubview:searchText];
    
    
    UIButton *labelsa = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 70,10 , 70, 30)];
    labelsa.titleLabel.font = Font14;
    [labelsa setTitle:@"搜索" forState:normal];
    [labelsa setTitleColor:titColor forState:normal];
    [labelsa addTarget:self action:@selector(didSouSuoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelsa];
    
    //
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 1)];
    lineView.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:lineView];
    
    //
    NSArray *titleaRR = [NSArray arrayWithObjects:@"全部",@"关节",@"时间", nil];
    for (int a= 0; a < 3; a ++) {
        UIButton *btns = [[UIButton alloc]initWithFrame:CGRectMake(0 + ScreenWidth/3* a, 51, ScreenWidth/3, 50)];
        btns.titleLabel.font = Font14;
        [btns setTitle:[NSString stringWithFormat:@"%@",titleaRR[a]] forState:normal];
        [btns setTitleColor:SetColor(0x1a1a1a) forState:normal];
        
        if (a == 0) {
            btns.selected = YES;
            self.selectedBtnOne = btns;
        }else{
            [btns setImage:[UIImage imageNamed:@"三角-选择"] forState:normal];
            [btns setImage:[UIImage imageNamed:@"三角_当前"] forState:UIControlStateSelected];
            [btns setTitleColor:SetColor(0x06a27b) forState:UIControlStateSelected];
        }
        [btns addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
        btns.tag = a + 20;
        btns.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
        btns.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        [self.view addSubview:btns];
        
    }
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 10)];
    views.backgroundColor = SetColor(0xf0f0f0);
    [self.view addSubview:views];
    
    huanZheTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, ScreenWidth, ScreenHeight - NavBarHeight - 110)];
    huanZheTable.delegate = self;
    huanZheTable.dataSource = self;
    huanZheTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:huanZheTable];
    [self maketableHeaderView];
    huanZheTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self makeSuiFanglist];
    }];

    huanZheTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self makeSuiFanglist];
    }];
    
    
    
    //heiseView
    heiseView = [[UIView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, ScreenHeight)];
    heiseView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view  addSubview:heiseView];
    heiseView.hidden = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewBlockView)];
    [heiseView addGestureRecognizer:tapGesture];
    
    tableviewOne = [[UITableView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, 44* 4)];
    tableviewOne.delegate = self;
    tableviewOne.dataSource = self;
    tableviewOne.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableviewOne];
    tableviewOne.hidden = YES;
    
}
#pragma mark textfield delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    heiseView.hidden = YES;
    tableviewOne.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    heiseView.hidden = YES;
    tableviewOne.hidden = YES;
    StrSearch = textField.text;
}
#pragma mark 黑色遮罩层点击事件
- (void)didViewBlockView{
    self.selectedBtnOne.selected = NO;
    heiseView.hidden =YES;
    tableviewOne.hidden = YES;
}
#pragma mark 顶部三个按钮点击事件
- (void)didButton:(UIButton *)sender{
    
    if (sender.tag == 20) {
        
//        stringOne = @"";
        [selectGuanjieDic removeAllObjects];
        inTime = @"";
        StrSearch = @"";
        searchText.text = @"";
        //        UIButton *jointsButton = (UIButton *)[self.view viewWithTag:21];
        //        [jointsButton setTitle:@"关节" forState:UIControlStateNormal];
        //        UIButton *timeButton = (UIButton *)[self.view viewWithTag:22];
        //        [timeButton setTitle:@"时间" forState:UIControlStateNormal];
        [resourceArr removeAllObjects];
        page  = 0 ;
        [self makeSuiFanglist];
        
    }else{
        if (sender.selected) {
            sender.selected = NO;
            heiseView.hidden = YES;
            tableviewOne.hidden = YES;
            
        }else{
//            self.selectedBtnOne.selected = NO;
            sender.selected = YES;
            if (sender.tag == 21) {
//                heiseView.hidden = NO;
//                tableviewOne.hidden = NO;
                [self makeSelectGuanjie ];
            }else if (sender.tag == 22){
                [self didTimeButton];
                heiseView.hidden = YES;
                tableviewOne.hidden = YES;
            }
        }
        self.selectedBtnOne = sender;
    }
    
    [searchText resignFirstResponder];
}

#pragma  mark 选关节
-(void)makeSelectGuanjie{
    ZhhuanChangViewController *zhuan = [[ZhhuanChangViewController alloc]init];
    zhuan.typeStr = @"1";
    zhuan.returnZhuan = ^(NSMutableArray *arr){
        
        self.selectedBtnOne.selected = NO;
        //         stringOne = [NSString stringWithFormat:@"%@",Arrone[indexPath.row][@"uid"]];
        selectGuanjieDic = arr;
        tableviewOne.hidden = YES;
        heiseView.hidden = YES;
        page = 0;
        [self makeSuiFanglist];
        [tableviewOne reloadData];//
    };
    zhuan.selectArray = selectGuanjieDic;
    zhuan.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhuan animated:NO];
    
    
}
#pragma mark 搜索框按钮点击事件
- (void)didSouSuoButton{
    heiseView.hidden =YES;
    tableviewOne.hidden = YES;
    [searchText resignFirstResponder];
    [resourceArr removeAllObjects];
    page  = 0 ;

    [self makeSuiFanglist];
}
#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == huanZheTable) {
        return resourceArr.count;
    }else{
        return Arrone.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == huanZheTable) {
        return 103;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == huanZheTable) {
        static NSString *cellIdter = @"cellId";
        WoDeShouShuTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:cellIdter];
        if (!cellTwo) {
            cellTwo = [[[NSBundle mainBundle]loadNibNamed:@"WoDeShouShuTableViewCell" owner:self options:nil] lastObject];
            cellTwo.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dicsa = resourceArr[indexPath.row];
        
        NSString *gerder = [NSString stringWithFormat:@"%@",[dicsa objectForKey:@"gender"]];
        if ([gerder isEqualToString:@"1"]) {
            cellTwo.nameLab.text = [NSString stringWithFormat:@"%@    男    %@岁",dicsa[@"patientName"],dicsa[@"age"]];
           
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicsa[@"portrait"]]] placeholderImage:[UIImage imageNamed:@"nan"]];
        }else{
            cellTwo.nameLab.text = [NSString stringWithFormat:@"%@    女    %@岁",dicsa[@"patientName"],dicsa[@"age"]];
            [cellTwo.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dicsa[@"portrait"]]] placeholderImage:[UIImage imageNamed:@"nv"]];
        }
        
        cellTwo.nameLab.text = [cellTwo.nameLab.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        cellTwo.numLab.text = [NSString stringWithFormat:@"住院号：%@   手术入路:%@",dicsa[@"hospNum"],dicsa[@"surgeryRoadName"]];
        cellTwo.mingchengLab.text = [NSString stringWithFormat:@"诊断情况：%@",dicsa[@"surgeryName"]];
        cellTwo.timeLab.text = [NSString stringWithFormat:@"诊疗时间：%@",dicsa[@"surgeryTime"]];
        cellTwo.timeLab.text = [cellTwo.timeLab.text stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        return cellTwo;
        
    }else{
        static NSString *cellOne= @"cellOne";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOne];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 20, 16)];
        imageOne.image = [UIImage imageNamed:@"TICK"];
        [cell.contentView addSubview:imageOne];
        imageOne.tag = indexPath.row + 10;
        imageOne.hidden = YES;
        
        UILabel *styleOneLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 200, 20)];
        styleOneLab.text = [NSString stringWithFormat:@"%@",Arrone[indexPath.row][@"jointsName"]];
        styleOneLab.tag = indexPath.row + 10;
        styleOneLab.font = Font14;
        [cell.contentView addSubview:styleOneLab];
        
        if (imageOne.tag == (tableNum + 10)) {
            imageOne.hidden = NO;
            styleOneLab.textColor = greenC;
        }else{
            imageOne.hidden = YES;
            styleOneLab.textColor = titColor;
        }
        
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == huanZheTable) {
        NSString *strings = resourceArr[indexPath.row][@"hospnumId"];
        
        NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
        [defau setObject:strings forKey:@"hospitalnumbar"];
        [defau synchronize];
        
        ShuHouSUFangViewController *shu = [[ShuHouSUFangViewController alloc]init];
        shu.numbers = 1;
        shu.infoDic = resourceArr[indexPath.row];
        shu.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:shu animated:NO];
        
    }else{
        self.selectedBtnOne.selected = NO;
        tableNum = indexPath.row;
        stringOne = [NSString stringWithFormat:@"%@",Arrone[indexPath.row][@"uid"]];
        tableviewOne.hidden = YES;
        heiseView.hidden = YES;
        
        [resourceArr removeAllObjects];
        page  = 0 ;

        [self makeSuiFanglist];
    }
}

#pragma mark 开始时间
- (void)didTimeButton{
    if(_DatePick==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        
        [Utile addClickEvent:self action:@selector(getCenterDatePicker) owner:_backWindowView];
        [self.view addSubview:_backWindowView];
        _DatePick = [[ZJNDatePickerView alloc]init];
        _DatePick.delegate = self;
        _DatePick.frame= CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        [self.view addSubview:_DatePick];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _DatePick.frame = CGRectMake(0, ScreenHeight-184 - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _DatePick.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, 184);
        } completion:^(BOOL finished) {
            [_DatePick removeFromSuperview];
            _DatePick = nil;
        }];
    }
    
}
-(void)getCenterDatePicker{
    UIButton *button = (UIButton *)[self.view viewWithTag:22];
    button.selected = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    
}
-(void)getSelectedDate:(NSString *)selectedDate{
    UIButton *button = (UIButton *)[self.view viewWithTag:22];
    button.selected = NO;
    inTime = [NSString stringWithFormat:@"%@", selectedDate];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _DatePick.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 184);
    } completion:^(BOOL finished) {
        [self.DatePick removeFromSuperview];
        self.DatePick = nil;
    }];
    [resourceArr removeAllObjects];
    page  = 0 ;

    [self makeSuiFanglist];
}
#pragma mark  添加headerView
-(void)maketableHeaderView{
    UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    numberLB  =[[UILabel alloc]initWithFrame:CGRectMake(30, 5, ScreenWidth -  80, 35)];
    numberLB.textColor =  [UIColor colorWithHex:666666];
    numberLB.font =[UIFont systemFontOfSize:13];
    [headerView addSubview:numberLB];
    huanZheTable.tableHeaderView  = headerView;
    
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
